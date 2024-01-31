# resource "aws_iam_role" "lambda_iam" {
#   name = var.lambda_role_name

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role_policy" "revoke_keys_role_policy" {
#   name = var.lambda_iam_policy_name
#   role = aws_iam_role.lambda_iam.id

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "s3:*",
#         "ses:*"
#       ],
#       "Effect": "Allow",
#       "Resource": "*"
#     }
#   ]
# }
# EOF
# }

# # data "aws_iam_policy_document" "assume_role" {
# #   statement {
# #     effect = "Allow"

# #     principals {
# #       type        = "Service"
# #       identifiers = ["lambda.amazonaws.com"]
# #     }

# #     actions = ["sts:AssumeRole"]
# #   }
# # }

# # resource "aws_iam_role" "iam_for_lambda_func" {
# #   name               = "iam_for_lambda_func"
# #   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# # }

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
