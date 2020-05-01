resource "random_integer" "randomId" {
  min = 10000
  max = 99999
  keepers = {
    team  = var.team
    stage = var.stage
  }
}

data "aws_iam_policy_document" "es_management_access" {
  count = false == local.inside_vpc ? 1 : 0


  statement {
    actions = [
      "es:*",
    ]


    resources = [
      aws_elasticsearch_domain.es[0].arn,
      "${aws_elasticsearch_domain.es[0].arn}/*",
    ]

    principals {
      type = "AWS"

      identifiers = distinct(compact(var.iam_role_arns))
    }
  }
}

resource "aws_elasticsearch_domain" "es" {
  count = false == local.inside_vpc ? 1 : 0


  domain_name           = local.domain_name
  elasticsearch_version = var.es_version

  encrypt_at_rest {
    enabled    = var.encrypt_at_rest
    kms_key_id = var.encrypt_at_rest_kms_key_id
  }

  cluster_config {
    instance_type = var.instance_type
    instance_count = var.instance_count
    dedicated_master_enabled = var.instance_count >= var.dedicated_master_threshold ? true : false
    dedicated_master_count = var.instance_count >= var.dedicated_master_threshold ? 3 : 0
    dedicated_master_type = var.instance_count >= var.dedicated_master_threshold ? var.dedicated_master_type != "false" ? var.dedicated_master_type : var.instance_type : ""
    zone_awareness_enabled = var.es_zone_awareness
    dynamic "zone_awareness_config" {
      for_each = var.es_zone_awareness ? [
        var.es_zone_awareness_count] : []
      content {
        availability_zone_count = var.es_zone_awareness_count
      }
    }

  }

  advanced_options = var.advanced_options

  dynamic "log_publishing_options" {
    for_each = var.log_publishing_options
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

      cloudwatch_log_group_arn = log_publishing_options.value.cloudwatch_log_group_arn
      enabled                  = lookup(log_publishing_options.value, "enabled", null)
      log_type                 = log_publishing_options.value.log_type
    }
  }

  node_to_node_encryption {
    enabled = var.node_to_node_encryption_enabled
  }

  vpc_options {
    subnet_ids         = var.subnet_ids
    security_group_ids = [join("", aws_security_group.default.*.id)]
  }

  ebs_options {
    ebs_enabled = var.ebs_volume_size > 0 ? true : false
    volume_size = var.ebs_volume_size
    volume_type = var.ebs_volume_type
  }

  snapshot_options {
    automated_snapshot_start_hour = var.snapshot_start_hour
  }

  tags = merge(
    local.required_tags,
    var.application_tags
  )
}

resource "aws_elasticsearch_domain_policy" "es_management_access" {
  count = false == local.inside_vpc ? 1 : 0
  domain_name     = local.domain_name
  access_policies = data.aws_iam_policy_document.es_management_access[0].json
}

resource "aws_ssm_parameter" "domainArn" {
  name  = "/${var.team}/${var.stage}/${var.business_domain}/elasticsearch/${var.domain_name}"
  type  = "String"
  value = aws_elasticsearch_domain.es[0].arn
}

resource "aws_ssm_parameter" "domainEndpoint" {
  name  = "/${var.team}/${var.stage}/${var.business_domain}/elasticsearch/${var.domain_name}/endpoint"
  type  = "String"
  value = aws_elasticsearch_domain.es[0].endpoint
}

module "elasticsearch" {
  source            = "../."
  app_id            = local.app_id
  cost_center       = local.cost_center
  team              = local.team
  stage             = local.stage
  business_domain   = local.business_domain
  domain_name       = local.domain_name
  es_version        = "6.5"
  instance_type     = "t2.medium.elasticsearch"
  instance_count    = 2
  encrypt_at_rest   = false
  iam_role_arns     = ["arn:aws:iam::560395879688:root"]
  es_zone_awareness = true
  es_zone_awareness_count = 2
  ebs_volume_size   = 10
  iam_actions       = ["es:*"]
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }
  node_to_node_encryption_enabled = false
  vpc_id                          = data.aws_vpc.vpc.id
  subnet_ids                      = slice(tolist(data.aws_subnet_ids.private_subnets.ids), 0, 2)
  allowed_cidr_blocks     = ["10.0.0.0/8"]
  ingress_from_port       = 443
  ingress_to_port         = 443
}

