resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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

resource "aws_lambda_function" "lambda_convert" {
  filename      = "${path.module}/lambda.zip"
  function_name = var.function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.handler_name
  timeout       = var.timeout
  memory_size   = var.memory_size
  publish       = true
  
  source_code_hash = filebase64sha256("${path.module}/lambda.zip")

  runtime = var.runtime

  environment {
    variables = var.environment
  }
}
