variable "lambda_aemet_opt_sqs_arn" {
  description = "ARN of the Lambda Function to invoke via EventBridge"
  type        = string
} # Value comes from main.tf

variable "lambda_aemet_opt_sqs_name" {
  description = "Name of the Lambda Function to invoke via EventBridge"
  type        = string
} # Value comes from main.tf
