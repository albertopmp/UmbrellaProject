variable "umbrella_sns_topic_arn" {
  description = "ARN of the SNS topic used for Umbre??a"
  type        = string
  default     = "arn:aws:sns:eu-west-1:095467007348:PeriodicUmbrellaNotifications"
}

variable "umbrella_sqs_queue_url" {
  description = "URL of the SQS queue used for Umbre??a"
  type        = string
} # Value comes from main.tf

variable "umbrella_sqs_queue_arn" {
  description = "ARN of the SQS queue used for Umbre??a"
  type        = string
} # Value comes from main.tf


variable "aemet_api_key" {
  description = "API key for AEMET"
  type        = string
  default     = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhbGJlcnRvcGFtcGlucDk5QGdtYWlsLmNvbSIsImp0aSI6IjFmZDc3ZTNmLTYxYzUtNDgzNi05OThjLTE2MTUwZTEwYmVhMyIsImlzcyI6IkFFTUVUIiwiaWF0IjoxNjU4NDE0NjQ2LCJ1c2VySWQiOiIxZmQ3N2UzZi02MWM1LTQ4MzYtOTk4Yy0xNjE1MGUxMGJlYTMiLCJyb2xlIjoiIn0.LRKaiFnBYgzZqqpmDs44-aGzLH3Qzly2810pXcXHoY0"
}

variable "umbrella_threshold" {
  description = "Threshold for Umbre??a true / false"
  type        = number
  default     = 35
}

variable "zip_route" {
  description = "Zip route for lambda python code"
  type        = string
  default     = "python_code/zip"
}

