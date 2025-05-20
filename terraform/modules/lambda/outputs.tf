# output "lambda_function_arns" {
#   value = [for lambda in aws_lambda_function.lambda_functions : lambda.arn]
# }

output "lambda_configs" {
  value = var.lambda_configs
}