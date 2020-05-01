resource "aws_dynamodb_table" "hashTable" {
  hash_key = "GitlabProjectId"


  billing_mode = "PAY_PER_REQUEST"
  name = "${local.team}-${var.stage}-${local.business_domain}-build-metrics"

  attribute {
    name = "GitlabProjectId"
    type = "S"
  }

}
resource "aws_ssm_parameter" "DbTableForMetricsCollector" {
  name = "/${local.team}/${var.stage}/${local.business_domain}/DbTableForMetricsCollector"
  type = "String"
  value = aws_dynamodb_table.hashTable.name
}


