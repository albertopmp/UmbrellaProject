terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.26.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0.0"
    }
  }
}

provider "aws" {
  region                   = "eu-west-1"
  shared_credentials_files = [".aws/credentials"] # SECRET IN GITHUB ACTIONS
}

module "sqs" {
  source = "./modules/sqs"
}

module "lambda" {
  source = "./modules/lambda"

  # From /sqs/output.tf
  umbrella_sqs_queue_url = module.sqs.queue_url
  umbrella_sqs_queue_arn = module.sqs.queue_arn

  depends_on = [
    module.sqs
  ]
}

module "event_bridge" {
  source = "./modules/event_bridge"

  # From /lambda/output.tf
  lambda_aemet_opt_sqs_name = module.lambda.aemet_opt_sqs_name
  lambda_aemet_opt_sqs_arn  = module.lambda.aemet_opt_sqs_arn

  depends_on = [
    module.lambda
  ]
}


module "api_gw" {
  source            = "./modules/api_gw"
  api_gw_account_id = var.account_id

  # From /lambda/output.tf
  lambda_aemet_opt_sqs_name       = module.lambda.aemet_opt_sqs_name
  lambda_aemet_opt_sqs_invoke_arn = module.lambda.aemet_opt_sqs_invoke_arn

  lambda_count_sns_topic_subs_name       = module.lambda.count_sns_topic_subs_name
  lambda_count_sns_topic_subs_invoke_arn = module.lambda.count_sns_topic_subs_invoke_arn

  depends_on = [
    module.lambda
  ]
}
