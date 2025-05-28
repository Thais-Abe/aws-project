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

variable "routes" {
  type = map(object({
    lambda_arn  = string
    lambda_name = string
    path        = string
    method      = string
  }))
}