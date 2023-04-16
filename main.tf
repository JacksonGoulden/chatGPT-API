
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

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "openai-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = data.archive_file.lambda-app-zip.output_path
  function_name = "Siri-chatGPT"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.test"

  layers = [aws_lambda_layer_version.lambda_layer.arn]
  
  runtime = "python3.9"

}