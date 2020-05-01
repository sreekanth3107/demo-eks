locals {
  # AppId assigned by InfoSec for the application
  infosec_app_id = "2331"
  # Cost center assigned for billing
  cost_center = "30138"
  # CI Type assigned for billing
  billing_ci_type = "NotApplicable"
  # "the team name to be used as part of resource names"
  team = "imncore"
  # The business domain of the service. claims, eligiblity, etc
  business_domain = "metrics"

  stage = "dev"


  required_tags = {
    APP_ID          = local.infosec_app_id
    COST_CENTER     = local.cost_center
    BUSINESS_DOMAIN = local.business_domain
    STAGE           = var.stage
    TEAM            = local.team
  }

}
