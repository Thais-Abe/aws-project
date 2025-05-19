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
