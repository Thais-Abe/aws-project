# provider "aws" {
#   region = "sa-east-1" # ajuste conforme necessário
# }
#
# resource "aws_iam_role" "lambda_exec_role" {
#   name = "lambda_exec_role"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Action = "sts:AssumeRole",
#       Principal = {
#         Service = "lambda.amazonaws.com"
#       },
#       Effect = "Allow",
#       Sid    = ""
#     }]
#   })
# }
#
# resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
#   role       = aws_iam_role.lambda_exec_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }
#
# resource "aws_lambda_function" "hello_lambda" {
#   function_name = "function-one"
#   role          = aws_iam_role.lambda_exec_role.arn
#   handler = "com.example.FunctionOneLambda::handleRequest"
#   runtime       = "java17"
#   filename      = "../target/hello-lambda-1.0-SNAPSHOT.jar"
#   source_code_hash = filebase64sha256("../target/hello-lambda-1.0-SNAPSHOT.jar")
# }


provider "aws" {
  region = "sa-east-1" # ajuste conforme necessário
}

# module "lambda" {
#   source      = "./modules/lambda"
#   function_name = "function-one"
#   handler     = "com.example.FunctionOneLambda::handleRequest"
#   runtime     = "java17"
#   filename    = "../target/hello-lambda-1.0-SNAPSHOT.jar"
# }
#
# module "lambda_function_two" {
#   source        = "./modules/lambda"
#   function_name = "function-two"
#   handler       = "org.example.FunctionTwo::handleRequest"
#   runtime       = "java17"
#   filename      = "../target/hello-lambda-1.0-SNAPSHOT.jar"
#
#   environment_variables = {
#     TABLE_NAME = module.dynamodb.dynamodb_table_name
#   }
# }

# resource "aws_iam_role" "lambda_exec_role" {
#   name = "lambda_exec_role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Action = "sts:AssumeRole",
#       Effect = "Allow",
#       Principal = {
#         Service = "lambda.amazonaws.com"
#       }
#     }]
#   })
# }

#comantado
# resource "aws_lambda_function" "lambda_functions" {
#   for_each = { for cfg in var.function_configs : cfg.function_name => cfg }
#
#   function_name    = each.value.function_name
#   handler          = each.value.handler
#   runtime          = each.value.runtime
#   filename         = each.value.filename
#   role             = aws_iam_role.lambda_exec_role.arn
#   source_code_hash = filebase64sha256(each.value.filename)
#
#   dynamic "environment" {
#     for_each = try(each.value.environment_vars, {}) != {} ? [1] : []
#     content {
#       variables = each.value.environment_vars
#     }
#   }
# }

variable "create_funcao_um" {
  type    = bool
  default = false
}

variable "create_funcao_dois" {
  type    = bool
  default = true
}

# Cria uma lista com as funções desejadas
locals {
  funcao_um = var.create_funcao_um ? [{
    function_name    = "funcao-um"
    handler          = "com.example.FunctionOneLambda::handleRequest"
    filename         = "${path.module}/lambdas/funcao-um/target/funcao-um-1.0-SNAPSHOT.jar"
    runtime          = "java11"
    environment_vars = {}
  }] : []

  funcao_dois = var.create_funcao_dois ? [{
    function_name    = "funcao-dois"
    handler          = "org.example.FunctionTwo::handleRequest"
    filename         = "${path.root}/../lambdas/funcao-dois/target/funcao-dois-1.0-SNAPSHOT.jar"
    runtime          = "java11"
    environment_vars = {
      TABLE_NAME = "MarketLists"
    }
  }] : []

  function_configs = concat(local.funcao_um, local.funcao_dois)
}

module "lambda" {
  source = "./modules/lambda"

  function_configs     = local.function_configs
#   lambda_role_arn      = aws_iam_role.lambda_exec_role.arn
  dynamodb_table_arn   = module.dynamodb.dynamodb_table_arn
  lambda_role_arn    =  "arn:aws:iam::936333283512:role/lambda_exec_role"
}


module "dynamodb" {
  source = "./modules/dynamodb"  # Caminho para o módulo DynamoDB

  dynamodb_table_name = var.dynamodb_table_name
  billing_mode        = var.billing_mode
  hash_key            = var.hash_key
  range_key           = var.range_key
}
