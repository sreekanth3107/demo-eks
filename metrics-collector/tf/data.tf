# VPC
data "aws_ssm_parameter" "vpcId" {
  name = "/${local.team}/${var.stage}/${local.business_domain}/deployments/vpcId"
}

data "aws_vpc" "vpc" {
  id = data.aws_ssm_parameter.vpcId.value
}

# Task Roles
data "aws_ssm_parameter" "lambdaRole" {
  name = "/${local.team}/${var.stage}/${local.business_domain}/deployments/lambdaRole"
}

data "aws_iam_role" "lambdaRole" {
  name = data.aws_ssm_parameter.lambdaRole.value
}

data "aws_security_group" "sg" {
  tags = {
    TEAM            = local.team
    STAGE           = var.stage
    BUSINESS_DOMAIN = local.business_domain
    SERVICE_NAME    = "metrics-collector"
  }
}

data "aws_ssm_parameter" "esDomainEndpoint" {
  name = "/${local.team}/${var.stage}/${local.business_domain}/devopsMetricsElasticSearchDomainEndpoint"
}
data "aws_secretsmanager_secret" "gitlabToken" {
  name = "imncore/dev/cicd/gitlab_token"
}
data "aws_ssm_parameter" "DbTableForMetricsCollector" {
  name = "/${local.team}/${var.stage}/${local.business_domain}/DbTableForMetricsCollector"
}