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

variable "user_pool_arn" {
  description = "ARN of the Cognito User Pool to be used by the API Gateway authorizer"
  type        = string
}