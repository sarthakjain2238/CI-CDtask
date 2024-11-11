# main.tf
provider "aws" {
  region = "ap-south-1" # or your preferred region
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "MyLambdaFunction"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"  # Updated runtime
  filename      = "lambda.zip"  # Lambda code package
}

resource "aws_iam_role" "lambda_role" {
  name = "LambdaRole"

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
      },
    ]
  })
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}
