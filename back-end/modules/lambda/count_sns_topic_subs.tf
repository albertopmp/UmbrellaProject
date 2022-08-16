resource "aws_iam_role" "count_sns_topic_subs" {
  name = "UmbrellaCountSNSTopicSubs"
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

resource "aws_iam_policy" "get_sns_topic_attributes" {
  name        = "UmbrellaGetSNSTopicAttributes"
  path        = "/"
  description = "AWS IAM Policy for managing UmbrellaCountSNSTopicSubs"

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
        Action : "sns:GetTopicAttributes"
        Effect : "Allow"
        Resource : var.umbrella_sns_topic_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_count_sns_topic_subs_role" {
  role       = aws_iam_role.count_sns_topic_subs.name
  policy_arn = aws_iam_policy.get_sns_topic_attributes.arn
}

data "archive_file" "zip_python_code_count_sns_topic_subs" {
  type        = "zip"
  source_dir  = "${path.module}/python_code/count_sns_topic_subs"
  output_path = "${path.module}/${var.zip_route}/count_sns_topic_subs.zip"
}

resource "aws_lambda_function" "count_sns_topic_subs" {
  filename      = "${path.module}/${var.zip_route}/count_sns_topic_subs.zip"
  function_name = "UmbrellaCountSNSTopicSubs"
  role          = aws_iam_role.count_sns_topic_subs.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.9"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_count_sns_topic_subs_role]

  environment {
    variables = {
      TOPIC_ARN = var.umbrella_sns_topic_arn
    }
  }
}
