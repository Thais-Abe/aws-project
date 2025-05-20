variable "dynamodb_table_name" {
  description = "Nome da tabela do DynamoDB"
  type        = string
}

variable "billing_mode" {
  description = "Modo de cobrança do DynamoDB"
  type        = string
}

variable "hash_key" {
  description = "Chave de partição"
  type        = string
}

variable "range_key" {
  description = "Chave de ordenação"
  type        = string
}

variable "dynamodb_table_arn" {
  description = "ARN da tabela DynamoDB"
  type        = string
}

variable "lambda_configs" {
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