locals {
  VpcTierLookup = {
    dev  = "MedicalTransactions"
    qa   = "MedicalTransactions-QA"
    cert = "MedicalTransactions-cert"
    prod = "MedicalTransactions"
  }

  VpcTier = local.VpcTierLookup[var.stage]
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Tier"
    values = [local.VpcTier]
  }
}

resource "aws_ssm_parameter" "vpcId" {
  name  = "/${local.team}/${var.stage}/${local.business_domain}/deployments/vpcId"
  type  = "String"
  value = data.aws_vpc.vpc.id
}
