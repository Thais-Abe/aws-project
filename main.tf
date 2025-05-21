provider "aws" {
  region = "sa-east-1"
}

module "dynamodb" {
  source = "./terraform/modules/dynamodb"
  dynamodb_table_name = var.dynamodb_table_name
  billing_mode        = var.billing_mode
  hash_key            = var.hash_key
  range_key           = var.range_key
}

module "iam" {
  source             = "./terraform/modules/iam"
  dynamodb_table_arn = module.dynamodb.dynamodb_table_arn
}

module "lambda_functions" {
  source = "./terraform/modules/lambda"

  lambda_configs  = var.lambda_configs
  lambda_role_arn = module.iam.lambda_exec_role_arn
}

module "cognito" {
  source             = "./terraform/modules/cognito"
  user_pool_name     = var.user_pool_name
}
