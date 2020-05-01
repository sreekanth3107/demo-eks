terraform {
  required_version = "=0.12.6"

  backend "s3" {
    key            = "imncore/devopsmetrics/infrastructure/dev/us-east-1/terraform.tfstate"
    bucket         = "imncore-chc-dev-medicaltransactions-terraform-state"
    dynamodb_table = "imncore-state-locking-table"
    profile        = "chc-dev"
    region         = "us-east-1"
  }
}
