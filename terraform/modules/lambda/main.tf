data "archive_file" "lambda_zips" {
  for_each    = var.lambda_configs
  type        = "zip"
  source_dir  = each.value.source_path
  output_path = "${path.module}/zip/${each.value.function_name}.zip"
}



# Cria uma Lambda para cada configuração
resource "aws_lambda_function" "lambda_functions" {
  for_each = var.lambda_configs

  function_name    = each.value.function_name
  handler          = each.value.handler
  runtime          = each.value.runtime
  filename         = data.archive_file.lambda_zips[each.key].output_path
  source_code_hash = data.archive_file.lambda_zips[each.key].output_base64sha256
  role             = var.lambda_role_arn

  environment {
    variables = each.value.environment_vars
  }

  timeout     = each.value.timeout
  memory_size = each.value.memory_size
}


