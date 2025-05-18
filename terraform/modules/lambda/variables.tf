variable "dynamodb_table_arn" {
  type        = string
  description = "ARN da tabela DynamoDB usada pelas funções Lambda"
  default     = null
}

variable "function_configs" {
  type = map(object({
    function_name    = string
    handler          = string
    filename         = string
    runtime          = string
    environment_vars = map(string)
  }))
  description = "Configuration for each lambda function"
}

variable "lambda_role_arn" {
  type        = string
  description = "ARN da role existente a ser usada pelas funções Lambda"
}

