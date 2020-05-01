terraform {
  required_version = "=0.12.6"

  backend "s3" {
    key            = "imncore/domain1/infrastructure/sandbox/us-east-2/terraform.tfstate"
    bucket         = "tfstate-east2-bucket-14sltotimw9tw"
    dynamodb_table = "tfstate-east2-Table-114RQ2BB7T92Q"
    profile        = "chc-sandbox"
    region         = "us-east-2"
  }
}
