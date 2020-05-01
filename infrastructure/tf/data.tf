data "aws_region" "current" {

}

// ES is limited to only 3 subnets
data "aws_subnet_ids" "es_subnets" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["AppSubnet1", "AppSubnet2", "AppSubnet3"]
  }
}