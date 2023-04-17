# Configure the AWS provider
provider "aws" {
  region = "ap-southeast-2"
}

# Create a Lambda layer to add the OpenAI python library to the Lambda function
# This uses the pre-built layer.zip file which contains the OpenAI python library
resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "layer.zip"
  layer_name = "openai-layer"

  compatible_runtimes = ["python3.9"]
}

# Zip the lambda_app.py file to create a zip file which will be used as the Lambda function source code
data "archive_file" "lambda-app-zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_app.py"
  output_path = "${path.module}/lambda_app.zip"
}

# Create an IAM role for the Lambda function
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

# Create a policy document to allow the Lambda function to log to CloudWatch
data "aws_iam_policy_document" "lambda-logging-policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

# Use the policy document to create a policy
resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.lambda-logging-policy.json
}

# Attach the policy to the Lambda function role
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

# Create a Lambda function
resource "aws_lambda_function" "chatGPT-lambda" {
  # Sets the path to the Lambda function source code. 
  # The source code is the lambda_app.py file which gets zipped in the data.archive_file.lambda-app-zip resource.
  filename      = data.archive_file.lambda-app-zip.output_path
  function_name = "Siri-chatGPT"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_app.lambda_handler"

  # Adds the openai layer to the Lambda function to allow it to use the OpenAI python library
  layers = [aws_lambda_layer_version.lambda_layer.arn]
  
  runtime = "python3.9"

}

# Create a log group for the Lambda function to send logs to
resource "aws_cloudwatch_log_group" "lambda-log-group" {
  name              = "/aws/lambda/${aws_lambda_function.chatGPT-lambda.function_name}"
  retention_in_days = 14
}