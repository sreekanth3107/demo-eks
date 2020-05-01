locals {
  required_tags = {
    APP_ID          = local.infosec_app_id
    CI_TYPE         = local.billing_ci_type
    COST_CENTER     = local.cost_center
    BUSINESS_DOMAIN = local.business_domain
    STAGE           = var.stage
    TEAM            = local.team
  }
}
