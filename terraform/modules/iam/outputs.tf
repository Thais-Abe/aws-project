output "lambda_exec_role_arn" {
  description = "ARN da IAM Role criada para a Lambda"
  value = aws_iam_role.lambda_exec_role.arn  
}

