variable "description" {
  description = "Description of what your Lambda Function does."
  default = "Resize image"
}

variable "function_name" {
  description = "A unique name for your Lambda Function"
  default     = "lambda_convert"
}

variable "handler_name" {
  description = "The function entrypoint in your code."
  default = "main.lambda_handler"
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime."
  default     = "128"
}

variable "runtime" {
  description = "runtime"
  default     = "python3.11"
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds. Defaults to 5 minutes"
  default     = "60"
}

variable "output_path" {
  description = "Path to the function's deployment package within local filesystem. eg: /path/to/lambda.zip"
  default     = "lambda.zip"
}

variable "environment" {
  description = "Environment configuration for the Lambda function"
  type        = map
  default     = {
    BUCKET_NAME = "my-bucket-test"
  }
}
