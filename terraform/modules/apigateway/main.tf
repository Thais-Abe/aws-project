# Criação da rest api

resource "aws_api_gateway_rest_api" "rest_api" {
  name = "rest-api"
  description = "Rest API for the application"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Authorizer cognito

resource "aws_api_gateway_authorizer" "cognito_auth" {
  name             = "CognitoAuthorizer"
  rest_api_id      = aws_api_gateway_rest_api.rest_api.id
  type             = "COGNITO_USER_POOLS"
  provider_arns    = [var.user_pool_arn]
  identity_source  = "method.request.header.Authorization"
}

# Criação dos recursos e métodos da API

resource "aws_api_gateway_resource" "api_resource" {
  for_each    = var.routes
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = trim(each.value.path, "/")
}

resource "aws_api_gateway_method" "method" {
  for_each      = var.routes
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.api_resource[each.key].id
  http_method   = each.value.method
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth.id
}

# Integração da api com a lambda

resource "aws_api_gateway_integration" "lambda_integration" {
  for_each                = var.routes
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.api_resource[each.key].id
  http_method             = aws_api_gateway_method.method[each.key].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${each.value.lambda_arn}/invocations"
}

#Permissão para o api gateway invocar a lambda

resource "aws_lambda_permission" "api_gateway_invoke" {
  for_each      = var.routes
  statement_id  = "AllowExecutionFromAPIGateway-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  triggers = {
    redeploy = sha1(jsonencode([
      for k in keys(var.routes) : aws_api_gateway_integration.lambda_integration[k].id
    ]))
  }

  depends_on = [
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_method.method
  ]
}

resource "aws_api_gateway_stage" "dev" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = "dev"
  deployment_id = aws_api_gateway_deployment.deployment.id
}
