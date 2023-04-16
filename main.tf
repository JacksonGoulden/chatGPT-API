# Configure the AWS provider
provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "layer.zip"
  layer_name = "openai-layer"

  compatible_runtimes = ["python3.9"]
}

data "archive_file" "lambda-app-zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_app.py"
  output_path = "${path.module}/lambda_app.zip"
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_example_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "chatGPT-lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = data.archive_file.lambda-app-zip.output_path
  function_name = "Siri-chatGPT"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "index.test"

  layers = [aws_lambda_layer_version.lambda_layer.arn]
  
  runtime = "python3.9"

}