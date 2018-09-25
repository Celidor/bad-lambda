resource "aws_lambda_function" "bad-lambda" {
  filename         = "files/bad-lambda.zip"
  function_name    = "bad-lambda-${terraform.workspace}"
  description      = "Deliberately vulnerable Lambda function - use with care"
  role             = "${aws_iam_role.lambda_iam.arn}"
  handler          = "index.handler"
  source_code_hash = "${base64sha256(file("files/bad-lambda.zip"))}"
  runtime          = "nodejs6.10"
  publish          = true

  tags {
    "Name"         = "bad-lambda-${terraform.workspace}"
    "Environment"  = "${terraform.workspace}"
  }
}
