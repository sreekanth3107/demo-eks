module "lambda" {
  source = "git::ssh://git@gitlab.healthcareit.net/imn/common/infra/tf-modules/imn-lambda.git"

  team                           = local.team
  business_domain                = local.business_domain
  app_id                         = local.infosec_app_id
  cost_center                    = local.cost_center
  stage                          = var.stage
  s3_key                         = var.function_s3_key
  description                    = "Lambda to collect metrics for the platform application teams"
  function_name                  = "metrics-collector"
  reserved_concurrent_executions = "2"
  runtime                        = "python3.6"
  handler                        = "main.handler"
  timeout_in_seconds             = 60

  imn_role          = data.aws_iam_role.lambdaRole.name
  vpc_id            = data.aws_vpc.vpc.id
  security_group_id = data.aws_security_group.sg.id

  application_custom_environment_variables = {
    DEVOPS_VPC_DASHBOARD_ENDPOINT = data.aws_ssm_parameter.esDomainEndpoint.value
    DB_TABLE_NAME = data.aws_ssm_parameter.DbTableForMetricsCollector.value
    GITLAB_TOKEN_SECRET_NAME = data.aws_secretsmanager_secret.gitlabToken.name
  }
}


resource "aws_cloudwatch_event_rule" "every_six_hours" {
  name_prefix         = "${local.team}-${local.business_domain}-pipelinesBuildMetrics-"
  schedule_expression = "rate(6 hours)"
  tags                = local.required_tags
}

resource "aws_cloudwatch_event_target" "every_six_hours" {
  arn  = module.lambda.function_arn
  rule = aws_cloudwatch_event_rule.every_six_hours.name
}

resource "aws_lambda_permission" "allowEventsToRunLambda" {
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.full_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_six_hours.arn
}

