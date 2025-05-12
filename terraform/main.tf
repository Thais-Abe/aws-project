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

module "lambda" {
  source      = "./modules/lambda"
  function_name = "function-one"
  handler     = "com.example.FunctionOneLambda::handleRequest"
  runtime     = "java17"
  filename    = "../target/hello-lambda-1.0-SNAPSHOT.jar"
}