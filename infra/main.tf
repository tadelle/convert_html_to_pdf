module "lambda_convert" {
  source = "./lambda_convert"
}

module "s3" {
  source = "./s3"
  depends_on = [ module.lambda_convert ]
}
