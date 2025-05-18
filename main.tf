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

# locals {
#   function_configs = merge(
#     var.create_funcao_um ? {
#       "funcao-um" = {
#         function_name    = "funcao-um"
#         handler          = "com.example.FunctionOneLambda::handleRequest"
#         filename         = "${path.module}/lambdas/funcao-um/target/funcao-um-1.0-SNAPSHOT.jar"
#         runtime          = "java11"
#         environment_vars = {}
#       }
#     } : {},
#     var.create_funcao_dois ? {
#       "funcao-dois" = {
#         function_name    = "funcao-dois"
#         handler          = "org.example.FunctionTwo::handleRequest"
#         filename         = "${path.root}/../lambdas/funcao-dois/target/funcao-dois-1.0-SNAPSHOT.jar"
#         runtime          = "java11"
#         environment_vars = {
#           TABLE_NAME = "todo-table"
#         }
#       }
#     } : {},
#     var.create_funcao_tres ? {
#       "funcao-tres" = {
#         function_name    = "funcao-tres"
#         handler          = "org.example.FunctionThree::handleRequest"
#         filename         = "${path.root}/../lambdas/funcao-tres/target/funcao-tres-1.0-SNAPSHOT.jar"
#         runtime          = "java11"
#         environment_vars = {
#           TABLE_NAME = "todo-table"
#         }
#       }
#     } : {},
#     var.create_funcao_quatro ? {
#        "funcao-quatro" = {
#          function_name    = "funcao-quatro"
#          handler          = "org.example.FunctionFour::handleRequest"
#          filename         = "${path.root}/../lambdas/funcao-quatro/target/funcao-quatro-1.0-SNAPSHOT.jar"
#          runtime          = "java11"
#          environment_vars = {
#          TABLE_NAME = "todo-table"
#          }
#       }
#     } : {}
#   )
# }

# module "lambda" {
#   source = "../terraform/modules/lambda"

# #   function_configs     = local.function_configs
#     function_configs = local.function_configs
# #   lambda_role_arn      = aws_iam_role.lambda_exec_role.arn
#   dynamodb_table_arn   = module.dynamodb.dynamodb_table_arn
#   lambda_role_arn    =  "arn:aws:iam::936333283512:role/lambda_exec_role"
# }


module "dynamodb" {
  source = "./terraform/modules/dynamodb"

  dynamodb_table_name = var.dynamodb_table_name
  billing_mode        = var.billing_mode
  hash_key            = var.hash_key
  range_key           = var.range_key
}

module "iam" {
  source             = "./terraform/modules/iam"
  dynamodb_table_arn = var.dynamodb_table_arn
}

module "lambda" {
  source          = "./terraform/modules/lambda" # Corrigido: remover o "../"
 lambda_role_arn = module.iam.lambda_exec_role_arn
  # lambda_role_arn = module.iam.lambda_role_arn

  function_configs = {
    lambda_add_items = {
      function_name = "lambda_add_items"
      handler       = "add_list_itens.lambda_add_to_list"
      runtime       = "python3.12"
      filename      = "src/lambdas-python/lambda-add-list-itens/lambda_add_itens.zip"
      environment_vars = {
        TABLE_NAME = "bakery-bank"
      }
    }
  }
}
