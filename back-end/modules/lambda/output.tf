# aemet_opt_sqs
output "aemet_opt_sqs_arn" {
  value = aws_lambda_function.aemet_opt_sqs.arn
}

output "aemet_opt_sqs_invoke_arn" {
  value = aws_lambda_function.aemet_opt_sqs.invoke_arn
}

output "aemet_opt_sqs_name" {
  value = aws_lambda_function.aemet_opt_sqs.function_name
}

# count_sns_topic_subs
output "count_sns_topic_subs_invoke_arn" {
  value = aws_lambda_function.count_sns_topic_subs.invoke_arn
}

output "count_sns_topic_subs_name" {
  value = aws_lambda_function.count_sns_topic_subs.function_name
}


