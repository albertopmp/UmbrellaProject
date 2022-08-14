output "count_sns_topic_subs_arn" {
  value = aws_lambda_function.count_sns_topic_subs.invoke_arn
}

output "count_sns_topic_subs_name" {
  value = aws_lambda_function.count_sns_topic_subs.function_name
}
