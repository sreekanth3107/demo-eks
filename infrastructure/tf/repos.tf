module "coordinator" {
  source = "git::ssh://git@gitlab.healthcareit.net/imn/common/infra/tf-modules/imn-ecr.git?ref=v1.0.0"

  repo_name = "coordinator"

  team            = local.team
  stage           = var.stage
  business_domain = local.business_domain
  billing_ci_type = local.billing_ci_type
  cost_center     = local.cost_center
  infosec_app_id  = local.infosec_app_id
}

module "reverse" {
  source = "git::ssh://git@gitlab.healthcareit.net/imn/common/infra/tf-modules/imn-ecr.git?ref=v1.0.0"

  repo_name = "reverse"

  team            = local.team
  stage           = var.stage
  business_domain = local.business_domain
  billing_ci_type = local.billing_ci_type
  cost_center     = local.cost_center
  infosec_app_id  = local.infosec_app_id
}

module "underscore" {
  source = "git::ssh://git@gitlab.healthcareit.net/imn/common/infra/tf-modules/imn-ecr.git?ref=v1.0.0"

  repo_name = "underscore"

  team            = local.team
  stage           = var.stage
  business_domain = local.business_domain
  billing_ci_type = local.billing_ci_type
  cost_center     = local.cost_center
  infosec_app_id  = local.infosec_app_id
}

module "uppercase" {
  source = "git::ssh://git@gitlab.healthcareit.net/imn/common/infra/tf-modules/imn-ecr.git?ref=v1.0.0"

  repo_name = "uppercase"

  team            = local.team
  stage           = var.stage
  business_domain = local.business_domain
  billing_ci_type = local.billing_ci_type
  cost_center     = local.cost_center
  infosec_app_id  = local.infosec_app_id
}

module "event-test" {
  source = "git::ssh://git@gitlab.healthcareit.net/imn/common/infra/tf-modules/imn-ecr.git?ref=v1.0.0"

  repo_name = "event-test"

  team            = local.team
  stage           = var.stage
  business_domain = local.business_domain
  billing_ci_type = local.billing_ci_type
  cost_center     = local.cost_center
  infosec_app_id  = local.infosec_app_id
}
