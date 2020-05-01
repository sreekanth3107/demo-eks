resource "aws_kms_key" "secretsEncryption" {
  tags = merge(
    local.required_tags,
    {
      Purpose = "SecretsEncryption"
    }
  )
}

resource "aws_ssm_parameter" "secretsEncryptionId" {
  name  = "/${local.team}/${var.stage}/${local.business_domain}/deployments/secretsEncryptionKeyId"
  type  = "String"
  value = aws_kms_key.secretsEncryption.id
}