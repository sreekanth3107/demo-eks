resource "aws_security_group" "metricscollector" {
  name_prefix = "${local.team}-${var.stage}-${local.business_domain}"
  vpc_id      = data.aws_vpc.vpc.id
  tags = merge(
    local.required_tags,
    {
      SERVICE_NAME = "metrics-collector"
    }
  )
}


resource "aws_security_group" "es_sg" {
  name_prefix = "${local.team}-${var.stage}-${local.business_domain}"
  description = "Allow inbound traffic to ElasticSearch from VPC CIDR"
  vpc_id      = data.aws_vpc.vpc.id
  tags = merge(
    local.required_tags,
    {
      SERVICE_NAME = "elasticsearchDomain"
    }
  )
}

resource "aws_security_group_rule" "ingress_es_sg" {
  security_group_id = aws_security_group.es_sg.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  type              = "ingress"
  cidr_blocks       = [local.apigeeCIDR]
}

resource "aws_security_group_rule" "ingress_from_lambda" {
  security_group_id        = aws_security_group.es_sg.id
  source_security_group_id = aws_security_group.metricscollector.id
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  type                     = "ingress"
}

resource "aws_security_group_rule" "egress_es_sg" {
  security_group_id = aws_security_group.es_sg.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}
