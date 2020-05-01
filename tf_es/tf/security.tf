resource "aws_security_group" "es_sg" {
  name = "${var.es_domain}-sg"
  description = "Allow inbound traffic to ElasticSearch from VPC CIDR"
  vpc_id = "${var.vpc}"
  ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = [
          "${var.vpc_cidr}"
      ]

  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}