resource "aws_iam_role" "subscribe_sns_topic" {
  name = "UmbrellaSubscribeSNSTopic"
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

resource "aws_iam_policy" "subscribe_sns_topic" {
  name        = "UmbrellaSubscribeSNSTopic"
  path        = "/"
  description = "AWS IAM Policy for managing UmbrellaSubscribeSNSTopic"

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
        Effect   = "Allow"
        Action   = "sns:Subscribe"
        Resource = var.umbrella_sns_topic_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_subscribe_sns_topic_role" {
  role       = aws_iam_role.subscribe_sns_topic.name
  policy_arn = aws_iam_policy.subscribe_sns_topic.arn
}

data "archive_file" "zip_python_code_subscribe_sns_topic" {
  type        = "zip"
  source_dir  = "${path.module}/python_code/subscribe_sns_topic"
  output_path = "${path.module}/${var.zip_route}/subscribe_sns_topic.zip"
}

resource "aws_lambda_function" "subscribe_sns_topic" {
  filename      = "${path.module}/${var.zip_route}/subscribe_sns_topic.zip"
  function_name = "UmbrellaSubscribeSNSTopic"
  role          = aws_iam_role.subscribe_sns_topic.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.9"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_subscribe_sns_topic_role]

  environment {
    variables = {
      TOPIC_ARN = var.umbrella_sns_topic_arn
    }
  }
}
