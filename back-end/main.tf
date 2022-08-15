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
  shared_credentials_files = ["/Users/albertopp/.aws/credentials"] # SECRET IN GITHUB ACTIONS
}

module "lambda" {
  source = "./modules/lambda"
}

module "api_gw" {
  source                           = "./modules/api_gw"
  api_gw_account_id                = var.account_id
  lambda_count_sns_topic_subs_name = module.lambda.count_sns_topic_subs_name # From /lambda/output.tf
  lambda_count_sns_topic_subs_arn  = module.lambda.count_sns_topic_subs_arn  # From /lambda/output.tf

  depends_on = [
    module.lambda
  ]
}
