

# IAM Role (compartilhada)
# IAM Role (compartilhada)
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

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

# Permissão do DynamoDB
resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
  name = "lambda-dynamodb-policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem"
      ],
      Effect   = "Allow",
      Resource = var.dynamodb_table_arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


# Cria uma Lambda para cada configuração
# resource "aws_lambda_function" "lambda_functions" {
#   for_each = { for cfg in var.function_configs : cfg.function_name => cfg }
#
#   function_name    = each.value.function_name
#   handler          = each.value.handler
#   runtime          = each.value.runtime
#   filename         = each.value.filename
#   source_code_hash = filebase64sha256(each.value.filename)
# #   role             = aws_iam_role.lambda_exec_role.arn
#   role = var.lambda_role_arn
#
#
#   environment {
#     variables = each.value.environment_vars
#   }
# }



# resource "aws_lambda_function" "funcao_tres_lambda" {
#   function_name = "funcao-tres"
#   handler       = "org.example.FunctionThreeRefactored::handleRequest"
#   runtime       = "java11" # Ou a runtime que você estiver usando
#   memory_size   = 512      # Ajuste conforme necessário
#   timeout       = 30       # Ajuste conforme necessário
#   s3_bucket     = "seu-bucket-de-deploy" # O bucket onde você fará upload do JAR
#   s3_key        = "funcao-tres-1.0-SNAPSHOT.jar" # O nome do JAR da funcao-tres
#   role          = aws_iam_role.lambda_exec_role_funcao_tres.arn # Crie uma nova role ou use uma existente
#
#   environment {
#     variables = {
#       TABLE_NAME = "seu-nome-da-tabela-dynamodb" # Ex: todo-table ou MarketLists
#     }
#   }
# }

# resource "aws_iam_role" "lambda_exec_role_funcao_tres" {
#   name = "lambda_exec_role_funcao_tres"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         }
#         Effect = "Allow"
#         Sid = ""
#       },
#     ]
#   })
# }

# resource "aws_iam_policy" "lambda_dynamodb_policy_funcao_tres" {
#   name        = "lambda_dynamodb_policy_funcao_tres"
#   description = "Permissões para a funcao-tres acessar o DynamoDB"
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "dynamodb:GetItem",
#           "dynamodb:UpdateItem"
#         ]
#         Effect   = "Allow"
#         Resource = "arn:aws:dynamodb:sa-east-1:SEU_ID_DA_CONTA:table/seu-nome-da-tabela-dynamodb" # Substitua pelo ARN correto
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "lambda_dynamodb_attach_funcao_tres" {
#   role       = aws_iam_role.lambda_exec_role_funcao_tres.name
#   policy_arn = aws_iam_policy.lambda_dynamodb_policy_funcao_tres.arn
# }
