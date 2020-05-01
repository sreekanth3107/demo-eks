# when we have VPN CIDR blocks we can replace the generic block below with
# "10.165.0.0/16" (corp dev airpark), "10.145.0.0/16" (corp dev memphis), "10.220.64.0/21" (for Apigee dev)

locals {
  ApigeeCIDR = {
    dev = {
      us-east-1 = {
        apigee_cidr = "10.0.0.0/8"
      }
    }
    qa = {
      us-east-1 = {
        apigee_cidr = "10.0.0.0/8"
      }
    }
    cert = {
      us-east-1 = {
        apigee_cidr = "10.221.128.0/21"
      }
    }
    prod = {
      us-east-1 = {
        apigee_cidr = "10.221.128.0/21"
      }
    }
  }
}

locals {
  apigeeCIDR = local.ApigeeCIDR[var.stage][data.aws_region.current.name].apigee_cidr
}
