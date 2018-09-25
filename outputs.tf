output "base_url" {
  value = "${aws_api_gateway_deployment.bad-lambda.invoke_url}"
}