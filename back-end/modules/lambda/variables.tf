variable "umbrella_sns_topic_arn" {
  description = "ARN of the SNS topic used for Umbre??a"
  type        = string
  default     = "arn:aws:sns:eu-west-1:095467007348:PeriodicUmbrellaNotifications"
}

variable "zip_route" {
  description = "Zip route for lambda python code"
  type        = string
  default     = "./python_code/zip/"
}

