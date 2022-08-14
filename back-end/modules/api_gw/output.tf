output "api_gw_subscribers" {
  value = "${aws_api_gateway_deployment.api_gw_deployment.invoke_url}${aws_api_gateway_stage.api_gw_stage.stage_name}${aws_api_gateway_resource.subscribers.path}"
}
