resource "aws_lambda_function" "bad-lambda" {
  filename         = "files/bad-lambda-dev-970b43c9-7b83-4ce3-aab0-cabc834cc8eb.zip"
  function_name    = "bad-lambda-${terraform.workspace}"
  description      = "Returns environment variables of container executing Lambda"
  role             = "${aws_iam_role.lambda_iam.arn}"
  handler          = "printenv.lambda_handler"
  source_code_hash = "${base64sha256(file("files/bad-lambda-dev-970b43c9-7b83-4ce3-aab0-cabc834cc8eb.zip"))}"
  runtime          = "python3.6"
  publish          = true

  tags {
    "Name"         = "bad-lambda-${terraform.workspace}"
    "Environment"  = "${terraform.workspace}"
  }
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.bad-lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_deployment.bad-lambda.execution_arn}/*/*"
}