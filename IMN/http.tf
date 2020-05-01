resource "aws_ssm_parameter" "domainName" {
  name  = "/${local.team}/${var.stage}/${local.business_domain}/http/domain"
  type  = "String"
  value = local.domain_name
}
