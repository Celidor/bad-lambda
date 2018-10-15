resource "aws_lambda_function" "bad-lambda" {
  filename         = "files/bad-lambda-dev-9322e8ba-fbba-4c52-ae92-a3b436da024e.zip"
  function_name    = "bad-lambda-${terraform.workspace}"
  description      = "Deliberately vulnerable Lambda function - use with care"
  role             = "${aws_iam_role.lambda_iam.arn}"
  handler          = "printenv.lambda_handler"
  source_code_hash = "${base64sha256(file("files/bad-lambda-dev-9322e8ba-fbba-4c52-ae92-a3b436da024e.zip"))}"
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