## Requirements
| Service | Version | Url |
| ------ | ------ | ------ |
| terraform | 1.4.2 | https://github.com/hashicorp/terraform |
| terraform-provider-google | 4.58.0 | https://github.com/hashicorp/terraform-provider-google |
| terragrunt | 0.45.0 | https://terragrunt.gruntwork.io/ |
| tfenv | 1.4.2 | https://github.com/tfutils/tfenv |
| tgenv | 0.45.0 | https://github.com/cunymatthieu/tgenv |
| tflint | 0.45.0 | https://github.com/terraform-linters/tflint |
| gcloud | 421.0.0 | https://cloud.google.com/sdk/docs/install?hl=ko |
| aws-cli | 2.7.11 | https://docs.aws.amazon.com/ko_kr/cli/latest/userguide/getting-started-install.html |

## Getting Started
1. Clone this repository to your local machine.
```bash
git clone https://github.com/PrrrStar/zero-trusted-pipeline
```
2. Change into the devops-infra directory.
```bash
cd zero-trusted-pipeline
```
3. Set up your GCP or AWS credentials.
```bash
# GCP auth with gcloud-cli
gcloud auth login

# AWS auth with aws-cli
aws configure
```
4. Initialize Terraform with terraform.
```bash
terraform init
```
5. Review the Terraform code and make any necessary changes.
6. Create the infrastructure.
```bash
terraform apply
```