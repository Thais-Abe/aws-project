
# IAM Role (compartilhada)
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



# Permissão do DynamoDB
# resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
#   name = "lambda-dynamodb-policy"
#   role = aws_iam_role.lambda_exec_role.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Action = [
#         "dynamodb:GetItem",
#         "dynamodb:PutItem",
#         "dynamodb:UpdateItem",
#         "dynamodb:DeleteItem"
#       ],
#       Effect   = "Allow",
#       Resource = var.dynamodb_table_arn
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "lambda_logging" {
#   role       = aws_iam_role.lambda_exec_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }

# Cria uma Lambda para cada configuração
resource "aws_lambda_function" "lambda_functions" {
  for_each = var.function_configs

  function_name    = each.value.function_name
  handler          = each.value.handler
  runtime          = each.value.runtime
  filename         = each.value.filename
  source_code_hash = filebase64sha256(each.value.filename)
  role             = var.lambda_role_arn

  environment {
    variables = each.value.environment_vars
  }
}


resource "aws_lambda_function" "lambda_add_items" {
  function_name = "lambda_add_items"
  role          = var.lambda_role_arn

  handler       = "add_list_itens.lambda_add_to_list"  # <nome_do_arquivo_python_sem_extensão>.<nome_da_função>
  runtime       = "python3.12"  # Altere para a versão do Python que você está usando
  filename      = "src/lambdas-python/lambda-add-list-itens/lambda_add_itens.zip"

  source_code_hash = filebase64sha256("src/lambdas-python/lambda-add-list-itens/lambda_add_itens.zip")
}