module "elasticsearch" {
  source      = "git::ssh://git@gitlab.healthcareit.net/imn/common/infra/tf-modules/imn-elasticsearch.git"
  domain_name = "build-metrics"

  app_id                     = local.app_id
  cost_center                = local.cost_center
  team                       = local.team
  stage                      = local.stage
  business_domain            = local.business_domain
  es_version                 = "6.5"
  instance_type              = "t4.medium.elasticsearch"
  instance_count             = 2
  encrypt_at_rest            = false
  iam_role_arns = ["arn:aws:iam::560395879688:root"]
  es_zone_awareness       = true
  es_zone_awareness_count = 2
  ebs_volume_size         = 10
  iam_actions             = ["es:*"]
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }
  node_to_node_encryption_enabled = false
  vpc_id                          = data.aws_vpc.vpc.id
  subnet_ids                      = slice(tolist(data.aws_subnet_ids.private_subnets.ids), 0, 2)
  allowed_cidr_blocks             = ["10.0.0.0/8"]
  ingress_from_port       = 443
  ingress_to_port         = 443


}

