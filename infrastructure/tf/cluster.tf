module "cluster" {
  source = "git::ssh://git@gitlab.healthcareit.net/imn/common/infra/tf-modules/imn-cluster-fargate.git"

  team            = local.team
  stage           = var.stage
  business_domain = local.business_domain
  cluster_name    = "cluster"
  infosec_app_id  = local.infosec_app_id
  cost_center     = local.cost_center
  billing_ci_type = local.billing_ci_type
}

resource "aws_ssm_parameter" "clusterName" {
  name  = "/${local.team}/${var.stage}/${local.business_domain}/deployments/fargateClusterName"
  type  = "String"
  value = module.cluster.ecs_cluster_name
}

