resource "aws_iam_role" "aemet_opt_sqs" {
  name = "UmbrellaAEMET_OPT_SQS"
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

resource "aws_iam_policy" "publish_to_sqs" {
  name        = "UmbrellaPublishToSQS"
  path        = "/"
  description = "AWS IAM Policy for managing UmbrellaAEMET_OPT_SQS"

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
        Action   = "sqs:SendMessage"
        Resource = var.umbrella_sqs_queue_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_aemet_opt_sqs_role" {
  role       = aws_iam_role.aemet_opt_sqs.name
  policy_arn = aws_iam_policy.publish_to_sqs.arn
}

data "archive_file" "zip_python_code_aemet_opt_sqs" {
  type        = "zip"
  source_dir  = "${path.module}/python_code/aemet_opt_sqs"
  output_path = "${path.module}/${var.zip_route}/aemet_opt_sqs.zip"
}

resource "aws_lambda_function" "aemet_opt_sqs" {
  filename      = "${path.module}/${var.zip_route}/aemet_opt_sqs.zip"
  function_name = "UmbrellaAEMET_OPT_SQS"
  role          = aws_iam_role.aemet_opt_sqs.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.9"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_aemet_opt_sqs_role]

  environment {
    variables = {
      API_KEY            = var.aemet_api_key,
      QUEUE_URL          = var.umbrella_sqs_queue_url,
      UMBRELLA_THRESHOLD = var.umbrella_threshold
    }
  }
}
