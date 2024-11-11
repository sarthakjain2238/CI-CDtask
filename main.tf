# main.tf
provider "aws" {
  region = "ap-south-1"  # Specify your region
}

resource "random_string" "suffix" {
  length  = 4
  special = false
}

resource "aws_iam_role" "lambda_role" {
  name = "LambdaRole-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "MyLambdaFunction-${random_string.suffix.result}"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  filename      = "lambda.zip"  # This zip file should contain your Lambda code
  timeout       = 3
  memory_size   = 128
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}
