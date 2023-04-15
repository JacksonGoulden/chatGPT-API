resource "aws_cloudformation_stack" "openai-lambda-layer" {
  name = "openai-layer"
  template_body = file("custom_lambda_layer.yaml")
  capabilities = ["CAPABILITY_NAMED_IAM"]
}