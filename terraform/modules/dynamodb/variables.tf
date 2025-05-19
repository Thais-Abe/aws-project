# terraform/dynamodb/variables.tf
variable "dynamodb_table_name" {
  type        = string
  description = "Nome da tabela do DynamoDB"
  default = "bakery-bank"
}

variable "billing_mode" {
  type        = string
  description = "Modo de cobrança da tabela do DynamoDB"
  default     = "PAY_PER_REQUEST" 
}

variable "hash_key" {
  type        = string
  description = "Chave hash da tabela"
}

variable "range_key" {
  type        = string
  description = "Chave de intervalo da tabela"
}
