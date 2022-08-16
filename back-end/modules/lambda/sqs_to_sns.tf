resource "aws_iam_role" "sqs_to_sns" {
  name = "UmbrellaSQS_TO_SNS"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "read_sqs_and_publish_sns" {
  name        = "UmbrellaReadSQSAndPublishSNS"
  path        = "/"
  description = "AWS IAM Policy for managing UmbrellaSQS_TO_SNS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action : [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ],
        Resource = var.umbrella_sqs_queue_arn
      },
      {
        Effect   = "Allow"
        Action   = "sns:Publish"
        Resource = var.umbrella_sns_topic_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_sqs_to_sns_role" {
  role       = aws_iam_role.sqs_to_sns.name
  policy_arn = aws_iam_policy.read_sqs_and_publish_sns.arn
}

data "archive_file" "zip_python_code_sqs_to_sns" {
  type        = "zip"
  source_dir  = "${path.module}/python_code/sqs_to_sns"
  output_path = "${path.module}/${var.zip_route}/sqs_to_sns.zip"
}

resource "aws_lambda_function" "sqs_to_sns" {
  filename      = "${path.module}/${var.zip_route}/sqs_to_sns.zip"
  function_name = "UmbrellaSQS_TO_SNS"
  role          = aws_iam_role.sqs_to_sns.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.9"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_sqs_to_sns_role]

  environment {
    variables = {
      TOPIC_ARN = var.umbrella_sns_topic_arn
    }
  }
}

# Trigger this Lambda from SQS
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  event_source_arn = var.umbrella_sqs_queue_arn
  enabled          = true
  function_name    = aws_lambda_function.sqs_to_sns.arn
  batch_size       = 1
}
