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

}


  # tags = {
  #   Environment = "dev"
  #   Project     = "todo-list"
  # }



  # Atributo para hash_key (OBRIGATÓRIO)
#   attribute {
#     name = var.hash_key
#     type = "S"  # String
#   }

#   # Atributo para range_key (condicional)
#   dynamic "attribute" {
#     for_each = var.range_key != null ? [1] : []
#     content {
#       name = var.range_key
#       type = "S"  # String
#     }
#   }
# }


