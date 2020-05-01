module "main" {
  source = "../.."
  stage = "dev"
  app_id = "1552"
  business_domain = "build-metrics"
  cost_center = "40153"
  team = "imncore"
  vpc_id = "vpc-0c0efd6a"
}