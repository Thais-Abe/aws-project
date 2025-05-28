# Criação da api http

resource "aws_apigatewayv2_api" "http_api" {
  name          = "http-api"
  protocol_type = "HTTP"
}

# Integração da api com a lambda

resource "aws_apigatewayv2_integration" "lambda_integration" {
  for_each               = var.routes
  api_id                 = aws_apigatewayv2_api.http_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${each.value.lambda_arn}/invocations"
  integration_method     = "POST"
  payload_format_version = "2.0"
}

# Authorizer cognito

resource "aws_apigatewayv2_authorizer" "cognito_auth" {
  name             = "CognitoAuthorizer"
  api_id           = aws_apigatewayv2_api.http_api.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  jwt_configuration {
    audience = [var.cognito_app_client_id]
    issuer   = "https://cognito-idp.${var.region}.amazonaws.com/${var.cognito_user_pool_id}"
  }
}

resource "aws_apigatewayv2_route" "lambda_route" {
  for_each  = var.routes
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "${each.value.method} ${each.value.path}"

  target             = "integrations/${aws_apigatewayv2_integration.lambda_integration[each.key].id}"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito_auth.id
  authorization_type = "JWT"
}

#Permissão para o api gateway invocar a lambda

resource "aws_lambda_permission" "api_gateway_invoke" {
  for_each      = var.routes
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = each.value.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}
