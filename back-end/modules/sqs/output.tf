output "queue_arn" {
  value = aws_sqs_queue.umbrella_queue.arn
}

output "queue_url" {
  value = aws_sqs_queue.umbrella_queue.url
}
