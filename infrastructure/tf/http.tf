locals {
  HttpMap = {
    sand = {
      us-east-2 = {
        domain_name = "imncore.sand-r53.domain1.local"
      }
      us-west-2 = {
        domain_name = "imncore.sand-w2.domain1.local"
      }
    }
    dev = {
      us-east-1 = {
        domain_name = "imncoresample.awsnonprod.healthcareit.net"
      }
    }
    qa = {
      us-east-1 = {
        domain_name = "imncoresample.qa.awsnonprod.healthcareit.net"
      }
    }
    cert = {
      us-east-1 = {
        domain_name = "imncoresample.cert.awsprod.healthcareit.net"
      }
    }
    prod = {
      us-east-1 = {
        domain_name = "imncoresample.awsprod.healthcareit.net"
      }
    }
  }
}

locals {
  services_domain_name = local.HttpMap[var.stage][data.aws_region.current.name].domain_name
}

resource "aws_ssm_parameter" "servicesDomainName" {
  name  = "/${local.team}/${var.stage}/${local.business_domain}/http/servicesDomainName"
  type  = "String"
  value = local.services_domain_name
}
