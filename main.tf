provider "aws" {
  region = "sa-east-1"
}

# variable "create_funcao_um" {
#   type    = bool
#   default = false
# }

# variable "create_funcao_dois" {
#   type    = bool
#   default = false
# }

# variable "create_funcao_tres" {
#   type    = bool
#   default = false
# }

# variable "create_funcao_quatro" {
#   type    = bool
#   default = false
# }


module "dynamodb" {
  source = "./terraform/modules/dynamodb"

  dynamodb_table_name = var.dynamodb_table_name
  billing_mode        = var.billing_mode
  hash_key            = var.hash_key
  range_key           = var.range_key
}



module "iam" {
  source = "./terraform/modules/iam"

  dynamodb_table_arn = var.dynamodb_table_arn
}


module "lambda_functions" {
  source = "./terraform/modules/lambda"

  function_configs = var.function_configs
  lambda_role_arn  =  module.iam.lambda_exec_role_arn 
}