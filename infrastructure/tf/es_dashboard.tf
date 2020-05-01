locals {
  StageMap = {
    dev = {
      instance_count = 3
      instance_type = "t2.medium.elasticsearch"
      encryption = false
    }
    qa = {
      instance_count = 3
      instance_type = "t2.medium.elasticsearch"
      encryption = false
    }
    cert = {
      instance_count = 3
      instance_type = "r5.large.elasticsearch"
      encryption = true
    }
    prod = {
      instance_count = 3
      instance_type = "r5.large.elasticsearch"
      encryption = true
    }
  }

  EsDomainName = "imncore-${var.stage}-devops"
  InstanceCount = local.StageMap[var.stage].instance_count
  InstanceType  = local.StageMap[var.stage].instance_type
  // Encryption is only available in certain instance sizes:
  // https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/aes-supported-instance-types.html
  EncryptionEnabled = local.StageMap[var.stage].encryption
}

resource "aws_elasticsearch_domain" "es" {
  domain_name           = local.EsDomainName
  elasticsearch_version = "7.1"

  advanced_options = {}

  vpc_options {
    subnet_ids = data.aws_subnet_ids.es_subnets.ids
    security_group_ids = [aws_security_group.es_sg.id]
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 20
    volume_type = "gp2"
  }

  encrypt_at_rest {
    enabled    = local.EncryptionEnabled
  }

  cluster_config {
    instance_count           = local.InstanceCount
    instance_type            = local.InstanceType
    dedicated_master_enabled = false
    zone_awareness_enabled   = true

    zone_awareness_config {
      availability_zone_count = length(data.aws_subnet_ids.es_subnets.ids)
    }
  }

  node_to_node_encryption {
    enabled = local.EncryptionEnabled
  }

  snapshot_options {
    automated_snapshot_start_hour = 0
  }
  
  tags = local.required_tags
}

resource "aws_ssm_parameter" "devopsMetricsElasticSearchDomainEndpoint" {
  name  = "/${local.team}/${var.stage}/${local.business_domain}/devopsMetricsElasticSearchDomainEndpoint"
  type  = "String"
  value = aws_elasticsearch_domain.es.endpoint
}