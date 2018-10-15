# Bad Lambda

Lambda function with API gateway
* Returns environment variables of container executing Lambda
* Includes AWS security token details which can be used to assume Lambda role

WARNING - could lead to AWS account takeover with excessive Lambda role policy permissions

## DEV environment

to deploy:

* use Terraform v11.7 to deploy:

```
terraform init
terraform workspace new dev
terraform plan
terraform apply
```
