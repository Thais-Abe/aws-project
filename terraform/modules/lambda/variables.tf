variable "dynamodb_table_arn" {
  type        = string
  description = "ARN da tabela DynamoDB usada pelas funções Lambda"
  default     = null
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

variable "lambda_role_arn" {
  type        = string
  description = "ARN da role existente a ser usada pelas funções Lambda"
}

