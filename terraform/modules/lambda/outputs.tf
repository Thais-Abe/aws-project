output "lambda_configs" {
  value = var.lambda_configs
}

output "lambda_arns" {
  value = { for key, lambda in aws_lambda_function.lambda_functions : key => lambda.arn }
}

output "lambda_names" {
  value = { for key, lambda in aws_lambda_function.lambda_functions : key => lambda.function_name }
}
