variable "lambda_arn" {
  description = "ARN da Lambda hello"
  type        = string
}

variable "lambda_name" {
  description = "Nome da Lambda hello"
  type        = string
}

variable "cognito_user_pool_id" {
  description = "ID do Cognito User Pool"
  type        = string
}

variable "cognito_app_client_id" {
  description = "ID do App Client do Cognito"
  type        = string
}

variable "region" {
  description = "Região AWS"
  type        = string
}
