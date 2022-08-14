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

resource "aws_lambda_permission" "api_gw_lambda" {
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
  uri                     = var.lambda_count_sns_topic_subs_arn
}

resource "aws_api_gateway_deployment" "api_gw_deployment" {
  rest_api_id = aws_api_gateway_rest_api.umbrella_api.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.subscribers.id,
      aws_api_gateway_method.count_sns_topic_subs.id,
      aws_api_gateway_integration.count_sns_topic_subs_integration.id
    ]))
  }
}
resource "aws_api_gateway_stage" "api_gw_stage" {
  deployment_id = aws_api_gateway_deployment.api_gw_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.umbrella_api.id
  stage_name    = var.api_gw_stage_name
}
