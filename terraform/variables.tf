variable "dynamodb_table_name" {
  description = "Nome da tabela do DynamoDB"
  type        = string
  default     = "bakery-bank"
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


variable "function_configs" {
  type = map(object({
    function_name    = string
    handler          = string
    runtime          = string
    filename         = string
    environment_vars = map(string)
    timeout          = number
    memory_size      = number
  }))
  description = "Configuration for Lambda functions"
}
