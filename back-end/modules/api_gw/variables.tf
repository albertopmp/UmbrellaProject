variable "api_gw_name" {
  description = "Name ot the REST API"
  type        = string
  default     = "UmbrellaAPI"
}

variable "api_gw_region" {
  description = "The region in which to create/manage resources"
  type        = string
  default     = "eu-west-1"
}

variable "api_gw_stage_name" {
  description = "The name of the API Gateway stage"
  type        = string
  default     = "prod"
}

variable "api_gw_account_id" {
  description = "The account ID in which to create/manage resources"
  type        = string
} # Value comes from main.tf

variable "lambda_count_sns_topic_subs_name" {
  type = string
} # Value comes from main.tf

variable "lambda_count_sns_topic_subs_arn" {
  type = string
} # Value comes from main.tf

