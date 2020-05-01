locals {
  required_tags = {
    APP_ID          = local.app_id
    COST_CENTER     = local.cost_center
    BUSINESS_DOMAIN = local.business_domain
    STAGE           = var.stage
    TEAM            = local.team
  }
}
