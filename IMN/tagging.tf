locals {
  required_tags = {
    APP_ID                      = var.app_id
    COST_CENTER                 = var.cost_center
    BUSINESS_DOMAIN             = var.business_domain
    STAGE                       = var.stage
    TEAM                        = var.team
    ES_DOMAIN_NAME              = var.domain_name
    IMN_PLATFORM                = true
    IMN_PLATFORM_MODULE         = "imn-elasticsearch"
    IMN_PLATFORM_MODULE_VERSION = "1.0"
  }
