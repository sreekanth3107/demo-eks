data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_subnet_ids" "private_subnets" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["AppSubnet*"]
  }
}
data "aws_caller_identity" "current" {}

data "aws_iam_role" "serviceLinkedRole" {
  name = "AWSServiceRoleForAmazonElasticsearchService"
}
locals {
  inside_vpc  = length(var.vpc_options["subnet_ids"]) > 0 ? true : false
}