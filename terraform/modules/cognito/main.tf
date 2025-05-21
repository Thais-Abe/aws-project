resource "aws_cognito_user_pool" "user_pool" {
    name = var.user_pool_name

    # política de senha
    password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
    }
  
    # verificação de e-mail
    auto_verified_attributes = ["email"]
    
    schema {
        name                = "email"
        attribute_data_type = "String"
        mutable             = true
        required            = true
    }
    
    # configuração de mensagens
    verification_message_template {
        default_email_option = "CONFIRM_WITH_CODE"
        email_subject        = "Seu Código de Verificação"
        email_message        = "Seu código de verificação é {####}"
    }
}

resource "aws_cognito_user_pool_client" "client" {
    name          = "api-client"
    user_pool_id  = aws_cognito_user_pool.user_pool.id
    
    # não gerar segredo para aplicações client-side
    generate_secret = false
    
    # fluxos de autenticação permitidos
    explicit_auth_flows = [
        "ALLOW_USER_PASSWORD_AUTH",
        "ALLOW_REFRESH_TOKEN_AUTH",
        "ALLOW_USER_SRP_AUTH"
    ]
  
    prevent_user_existence_errors = "ENABLED"

    refresh_token_validity = 30
    access_token_validity  = 1
    id_token_validity      = 1
}

resource "aws_iam_policy" "cognito_management" {
  name        = "cognito-management-policy"
  description = "Permite gerenciar recursos do AWS Cognito"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "cognito-idp:CreateUserPool",
          "cognito-idp:DeleteUserPool",
          "cognito-idp:DescribeUserPool",
          "cognito-idp:UpdateUserPool",
          "cognito-idp:ListUserPools",
          "cognito-idp:CreateUserPoolClient",
          "cognito-idp:DeleteUserPoolClient",
          "cognito-idp:UpdateUserPoolClient",
          "cognito-idp:DescribeUserPoolClient",
          "cognito-idp:ListUserPoolClients",
          "cognito-idp:SetUserPoolMfaConfig",
          "cognito-idp:GetUserPoolMfaConfig"
        ],
        Resource = "*"
      }
    ]
  })
}