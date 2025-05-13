# terraform/dynamodb/main.tf
resource "aws_dynamodb_table" "todo_table" {
  name         = var.dynamodb_table_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key
  range_key    = var.range_key

  attribute {
    name = var.hash_key
    type = "S"
  }

  attribute {
    name = var.range_key
    type = "S"
  }

  tags = {
    Environment = "dev"
    Project     = "todo-list"
  }
#
#   output "dynamodb_table_name" {
#     value = module.dynamodb.dynamodb_table_name
#   }
#
# module "dynamodb" {
#   source = "./modules/dynamodb"  # Caminho correto para o módulo DynamoDB
# }
#
# output "dynamodb_table_name" {
#   value = module.dynamodb.dynamodb_table_name
# }
#
# output "dynamodb_table_arn" {
#   value = module.dynamodb.dynamodb_table_arn
# }

}
