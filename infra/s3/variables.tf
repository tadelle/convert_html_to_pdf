variable "lambda_role_name" {
  type        = string
  description = "Name of the role to be created for the Lambda function"
  default     = "lambda-role"
}

variable "lambda_iam_policy_name" {
  type        = string
  description = "Name of the IAM policy to be created for the Lambda function"
  default     = "lambda-iam-policy"
}

variable "lambda_function_name" {
  type        = string
  description = "Name of the Lambda function"
  default     = "lambda_convert"
}
