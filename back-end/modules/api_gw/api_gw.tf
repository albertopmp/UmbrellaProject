resource "aws_api_gateway_rest_api" "umbrella_api" {
  name = var.api_gw_name

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


#  count_sns_topic_subs
resource "aws_api_gateway_resource" "subscribers" {
  rest_api_id = aws_api_gateway_rest_api.umbrella_api.id
  parent_id   = aws_api_gateway_rest_api.umbrella_api.root_resource_id
  path_part   = "subscribers"
}

resource "aws_api_gateway_method" "count_sns_topic_subs" {
  rest_api_id   = aws_api_gateway_rest_api.umbrella_api.id
  resource_id   = aws_api_gateway_resource.subscribers.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_lambda_permission" "execute_count_sns_topic_subs" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_count_sns_topic_subs_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.api_gw_region}:${var.api_gw_account_id}:${aws_api_gateway_rest_api.umbrella_api.id}/*/${aws_api_gateway_method.count_sns_topic_subs.http_method}${aws_api_gateway_resource.subscribers.path}"
}

resource "aws_api_gateway_integration" "count_sns_topic_subs_integration" {
  rest_api_id             = aws_api_gateway_rest_api.umbrella_api.id
  resource_id             = aws_api_gateway_resource.subscribers.id
  http_method             = aws_api_gateway_method.count_sns_topic_subs.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_count_sns_topic_subs_invoke_arn
}


#  aemet_opt_sqs
resource "aws_api_gateway_resource" "umbrella" {
  rest_api_id = aws_api_gateway_rest_api.umbrella_api.id
  parent_id   = aws_api_gateway_rest_api.umbrella_api.root_resource_id
  path_part   = "umbrella"
}

resource "aws_api_gateway_resource" "mncp" {
  rest_api_id = aws_api_gateway_rest_api.umbrella_api.id
  parent_id   = aws_api_gateway_resource.umbrella.id
  path_part   = "{mncp}"
}

resource "aws_api_gateway_method" "aemet_opt_sqs" {
  rest_api_id   = aws_api_gateway_rest_api.umbrella_api.id
  resource_id   = aws_api_gateway_resource.mncp.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.mncp" = true
  }
}

resource "aws_lambda_permission" "execute_aemet_opt_sqs" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_aemet_opt_sqs_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.api_gw_region}:${var.api_gw_account_id}:${aws_api_gateway_rest_api.umbrella_api.id}/*/${aws_api_gateway_method.aemet_opt_sqs.http_method}${aws_api_gateway_resource.mncp.path}"
}

resource "aws_api_gateway_integration" "aemet_opt_sqs_integration" {
  rest_api_id             = aws_api_gateway_rest_api.umbrella_api.id
  resource_id             = aws_api_gateway_resource.mncp.id
  http_method             = aws_api_gateway_method.aemet_opt_sqs.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_aemet_opt_sqs_invoke_arn

  request_parameters = {
    "integration.request.path.id" = "method.request.path.mncp"
  }
}


# Deployment
resource "aws_api_gateway_deployment" "api_gw_deployment" {
  rest_api_id = aws_api_gateway_rest_api.umbrella_api.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.subscribers.id,
      aws_api_gateway_method.count_sns_topic_subs.id,
      aws_api_gateway_integration.count_sns_topic_subs_integration.id,

      aws_api_gateway_resource.umbrella.id,
      aws_api_gateway_method.aemet_opt_sqs.id,
      aws_api_gateway_integration.aemet_opt_sqs_integration.id
      # ...
      # Add more resources, methods and integrations
      # ...
    ]))
  }
}
resource "aws_api_gateway_stage" "api_gw_stage" {
  deployment_id = aws_api_gateway_deployment.api_gw_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.umbrella_api.id
  stage_name    = var.api_gw_stage_name
}
