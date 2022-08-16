resource "aws_sqs_queue" "umbrella_queue" {
  name                      = var.umbrella_sqs_queue_name
  delay_seconds             = 30
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
}
