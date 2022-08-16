resource "aws_cloudwatch_event_rule" "umbrella_daily_event" {
  name                = "UmbrellaPeriodicRule"
  description         = "This rule should activate every day at 6:30 am Madrid (UTC+2) \"aemet_opt_sqs\" Lambda Function"
  schedule_expression = "cron(30 4 * * ? 2022)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  arn  = var.lambda_aemet_opt_sqs_arn
  rule = aws_cloudwatch_event_rule.umbrella_daily_event.name
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_rw_fallout_retry_step_deletion_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_aemet_opt_sqs_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.umbrella_daily_event.arn
}
