module "main" {
  source = "../.."

  stage = "dev"
  app_id = "1552"
  business_domain = "metricsdashboard"
  cost_center = "40153"
  team = "imncore"
  vpc_id = "vpc-0c0efd6a"
}
