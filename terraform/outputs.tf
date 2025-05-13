# output "dynamodb_table_name" {
#   value = aws_dynamodb_table.todo_table.name
# }
#

output "lambda_function_arns" {
  value = module.lambda.lambda_function_arns
}
