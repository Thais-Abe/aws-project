variable "lock_table_name" {
  type        = string
  description = "Nome da tabela DynamoDB usada para locking do Terraform"
}

variable "billing_mode" {
  type        = string
  description = "Modo de cobrança da tabela do DynamoDB"
}
