data "aws_lambda_function" "func" {
  function_name = var.lambda_function_name
}

resource "aws_s3_bucket" "test-bucket" {
  bucket = "my-bucket-test"
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
    Product     = "Teste"
  }
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.test-bucket.id

  lambda_function {
    lambda_function_arn = data.aws_lambda_function.func.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "html/"
    filter_suffix       = ".html"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.test-bucket.arn
}
