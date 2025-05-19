variable "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB"
  type        = string
  default     = "bakery-bank"
}

variable "billing_mode" {
  description = "Modo de cobrança do DynamoDB (PAY_PER_REQUEST ou PROVISIONED)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "Chave de partição da tabela DynamoDB"
  type        = string
  default     = "name"
}

variable "range_key" {
  description = "Chave de ordenação da tabela DynamoDB"
  type        = string
  default     = "date"
}

variable "dynamodb_table_arn" {
  description = "ARN da tabela DynamoDB"
  type        = string
  default     = "arn:aws:dynamodb:sa-east-1:936333283512:table/bakery-bank"

}

variable "lambda_role_arn" {
  description = "ARN da IAM Role usada pela função Lambda"
  type        = string
  default     = "arn:aws:iam::936333283512:role/default-lambda-role"
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
