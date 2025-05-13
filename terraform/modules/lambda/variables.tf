# variable "function_name" {
#   description = "The name of the Lambda function"
#   type        = string
# }

# variable "handler" {
#   description = "The function handler"
#   type        = string
# }

# variable "runtime" {
#   description = "The runtime environment for the Lambda function"
#   type        = string
# }
#
# variable "filename" {
#   description = "The path to the deployment package"
#   type        = string
# }


# variable "lambda_role_arn" {
#   type        = string
#   description = "ARN da role usada pela função Lambda"
# }

variable "dynamodb_table_arn" {
  type        = string
  description = "ARN da tabela DynamoDB usada pelas funções Lambda"
  default     = null
}



variable "function_configs" {
  type = list(object({
    function_name    = string
    handler          = string
    filename         = string
    runtime          = string
    environment_vars = map(string)
  }))
}

variable "lambda_role_arn" {
  type        = string
  description = "ARN da role existente a ser usada pelas funções Lambda"
}
