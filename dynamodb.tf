locals {
  # AppId assigned by InfoSec for the application
  infosec_app_id = "2331"
  # Cost center assigned for billing
  cost_center = "30138"
  # CI Type assigned for billing
  billing_ci_type = "NotApplicable"
  # "the team name to be used as part of resource names"
  team = "imncore"
  # The business domain of the service. claims, eligiblity, etc
  business_domain = "Registration1"
}

variable "stage" {
  type        = string
  description = "stage name used as part of resource names. prod, dev, qa. this is populated by the ci pipeline"
}

resource "aws_dynamodb_table" "hashTable" {
  hash_key     = "GitlabProjectId"
  billing_mode = "PAY_PER_REQUEST"
  name         = "${local.team}-${var.stage}-${local.business_domain}-hashes"
  attribute {
    name = "GitlabProjectId"
    type = "S"
  }
  
  attribute {
    name = "GitlabProjectPath"
    type = "S"
  }
  
  attribute {
    name = "PlatformTeamName"
    type = "S"
  }
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
}
