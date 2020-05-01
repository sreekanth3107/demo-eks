module "main" {
  source = "../.."

  stage = "dev"
  function_s3_key = var.function_s3_key
}
