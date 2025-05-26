resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.lock_table_name
  billing_mode = var.billing_mode
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Purpose = "Terraform state lock table"
  }
}