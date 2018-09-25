resource "aws_iam_role" "lambda_iam" {
  name        = "bad-lambda-role-${terraform.workspace}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "lambda_iam" {
  name       = "bad-lambda-${terraform.workspace}-lambda-iam"
  roles      = [ "${aws_iam_role.lambda_iam.name}" ]
  policy_arn = "${aws_iam_policy.lambda_policy.arn}"
}

resource "aws_iam_policy" "lambda_policy" {
  name = "bad-lambda-${terraform.workspace}-lambda-policy"
  path = "/"
  description = "Policy allows Lambda to write to CloudWatch"
  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement":[
     {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
        ]
     }
   ]
}
EOF
}
