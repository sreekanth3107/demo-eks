resource "aws_security_group" "default" {
  name_prefix = "${var.team}-${var.stage}-${var.business_domain}"
  vpc_id      = var.vpc_id
  description = "Allow inbound traffic from Security Groups and CIDRs. Allow all outbound traffic"
  tags = merge(
    local.required_tags,
    var.application_tags
  )
}

resource "aws_security_group_rule" "ingress_security_groups" {
  count                    = length(var.security_groups)
  description              = "Allow inbound traffic from Security Groups"
  type                     = "ingress"
  from_port                = var.ingress_from_port
  to_port                  = var.ingress_to_port
  protocol                 = "tcp"
  source_security_group_id = var.security_groups[count.index]
  security_group_id        = join("", aws_security_group.default.*.id)
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  count             = length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  description       = "Allow inbound traffic from CIDR blocks"
  type              = "ingress"
  from_port         = var.ingress_from_port
  to_port           = var.ingress_to_port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = join("", aws_security_group.default.*.id)
}

resource "aws_security_group_rule" "egress" {
  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.default.*.id)
}
