resource "aws_ssm_parameter" "taskExecutionRole" {
  name  = "/${local.team}/${var.stage}/${local.business_domain}/deployments/taskExecutionRole"
  type  = "String"
  value = "IMNCore-SA-EcsTaskExecution"
}

resource "aws_ssm_parameter" "taskRole" {
  name  = "/${local.team}/${var.stage}/${local.business_domain}/deployments/taskRole"
  type  = "String"
  value = "IMNCore-SA-EcsTask"
}

resource "aws_ssm_parameter" "lambdaRole" {
  name  = "/${local.team}/${var.stage}/${local.business_domain}/deployments/lambdaRole"
  type  = "String"
  value = "IMNCore-SA-Lambda"
}

resource "aws_ssm_parameter" "codeDeployRole" {
  name  = "/${local.team}/${var.stage}/${local.business_domain}/deployments/codeDeployRole"
  type  = "String"
  value = "IMNCore-ECSCodeDeploy"
}
