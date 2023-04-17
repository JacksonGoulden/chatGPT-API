# Create an API Gateway REST API
resource "aws_api_gateway_rest_api" "chatGPT-API-GW" {
  name        = "chatGPT-API-GW"
  description = "API to trigger the chatGPT lambda function"
  # api_key_source = aws_api_gateway_api_key.chatGPT-API-key.id
}

# Create an API Gateway resource for the Lambda function
resource "aws_api_gateway_resource" "example_lambda_resource" {
  rest_api_id = aws_api_gateway_rest_api.chatGPT-API-GW.id
  parent_id   = aws_api_gateway_rest_api.chatGPT-API-GW.root_resource_id
  path_part   = "{proxy+}"
}

# Create an API Gateway method for the Lambda function
resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.chatGPT-API-GW.id
  resource_id   = aws_api_gateway_resource.example_lambda_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Create an integration between the API Gateway method and the Lambda function
resource "aws_api_gateway_integration" "example_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chatGPT-API-GW.id
  resource_id             = aws_api_gateway_method.proxy.resource_id
  http_method             = aws_api_gateway_method.proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.chatGPT-lambda.invoke_arn
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.chatGPT-API-GW.id
  resource_id   = aws_api_gateway_rest_api.chatGPT-API-GW.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id             = aws_api_gateway_rest_api.chatGPT-API-GW.id
  resource_id             = aws_api_gateway_method.proxy_root.resource_id
  http_method             = aws_api_gateway_method.proxy_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.chatGPT-lambda.invoke_arn
}

# Create a deployment for the API Gateway
resource "aws_api_gateway_deployment" "gpt-api-deployment" {
  depends_on = [
    aws_api_gateway_integration.example_lambda_integration,
    aws_api_gateway_integration.lambda_root,
  ]
  
  rest_api_id = aws_api_gateway_rest_api.chatGPT-API-GW.id
  stage_name  = "dev"
}

resource "aws_lambda_permission" "lambda_API_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.chatGPT-lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # The /* part allows invocation from any stage, method and resource path
  # within API Gateway.
  source_arn = "${aws_api_gateway_rest_api.chatGPT-API-GW.execution_arn}/*"
}

# Output the API endpoint URL and API key
output "base_url" {
  value = "${aws_api_gateway_deployment.gpt-api-deployment.invoke_url}"
}
