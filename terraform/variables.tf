variable "dynamodb_table_name" {
  description = "Nome da tabela do DynamoDB"
  type        = string
  default     = "todo-table"
}

variable "billing_mode" {
  description = "Modo de cobrança do DynamoDB"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "Chave de partição"
  type        = string
  default     = "PK"
}

variable "range_key" {
  description = "Chave de ordenação"
  type        = string
  default     = "SK"
}
