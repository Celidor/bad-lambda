# Bad Lambda

* Lambda function with API gateway
* Returns the environment variables of container executing Lambda
* Includes AWS security token details which can be used to assume Lambda role

WARNING - this could lead to AWS account takeover if the Lambda role is excessive

## DEV environment

to deploy:

* use Terraform v11.7 to deploy:

```
terraform init
terraform workspace new dev
terraform plan
terraform apply
```
