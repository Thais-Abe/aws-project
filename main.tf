module "dynamodb" {
  source              = "./terraform/modules/dynamodb"
  dynamodb_table_name = var.dynamodb_table_name
  billing_mode        = var.billing_mode
  hash_key            = var.hash_key
  range_key           = var.range_key
}

module "dynamodb_lock" {
  source           = "./terraform/modules/dynamodb_lock"
  lock_table_name  = "terraform-locks"
  billing_mode     = var.billing_mode
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
  source         = "./terraform/modules/cognito"
  user_pool_name = var.user_pool_name
}


module "api_gateway" {
  source = "./terraform/modules/apigateway"

  lambda_arn            = module.lambda_functions.lambda_arns["lambda_hello"]
  lambda_name           = module.lambda_functions.lambda_names["lambda_hello"]
  cognito_user_pool_id  = module.cognito.user_pool_id
  cognito_app_client_id = module.cognito.app_client_id
  region                = "sa-east-1"
}