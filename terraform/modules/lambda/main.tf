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

  timeout = each.value.timeout
  memory_size = each.value.memory_size
}
