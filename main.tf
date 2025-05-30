module "dynamodb" {
  source              = "./terraform/modules/dynamodb"
  dynamodb_table_name = var.dynamodb_table_name
  billing_mode        = var.billing_mode
  hash_key            = var.hash_key
  range_key           = var.range_key
}

module "dynamodb_lock" {
  source          = "./terraform/modules/dynamodb_lock"
  lock_table_name = "terraform-locks"
  billing_mode    = var.billing_mode
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

  routes = {
    hello = {
      lambda_arn  = module.lambda_functions.lambda_arns["lambda_hello"]
      lambda_name = "lambda_hello"
      path        = "/hello"
      method      = "GET"
    }
    get_itens = {
      lambda_arn  = module.lambda_functions.lambda_arns["lambda_get_itens"]
      lambda_name = "lambda_get_itens"
      path        = "/list-itens"
      method      = "GET"
    },
    add_itens = {
      lambda_arn  = module.lambda_functions.lambda_arns["lambda_add_to_list"]
      lambda_name = "lambda_add_to_list"
      path        = "/add-itens"
      method      = "POST"
    },
    update_itens = {
      lambda_arn  = module.lambda_functions.lambda_arns["lambda_modify_itens"]
      lambda_name = "lambda_modify_itens"
      path        = "/modify-itens"
      method      = "PUT"
    },
    delete_itens = {
      lambda_arn  = module.lambda_functions.lambda_arns["lambda_delete_itens"]
      lambda_name = "lambda_delete_itens"
      path        = "/delete-itens"
      method      = "DELETE"
    }
  }

  user_pool_arn = module.cognito.user_pool_arn
  region        = "sa-east-1"
}