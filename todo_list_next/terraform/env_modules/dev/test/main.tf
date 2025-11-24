# export $(grep -v '^#' ../../../../../.env | xargs)
# variable "ecr_registry_name" { type = string }
variable "aws_account_id" { type = string } # export TF_VAR_aws_account_id=${AWS_ACCOUNT_ID}
variable "route53_id" { type = string } # export TF_VAR_route53_id=${ROUTE53_HOSTZONE_ID}
variable "route53_name" { type = string } # export TF_VAR_route53_name=${ROUTE53_HOSTZONE_NAME}
variable "codebuild_artifact_s3_bucket" { type = string } # export TF_VAR_codebuild_artifact_s3_bucket=${CODEBUILD_ARTICACT_S3_BUCKET}
variable "aws_code_connection_id_to_github" { type = string } # export TF_VAR_aws_code_connection_id_to_github=${AWS_CODE_CONNECTION_ID_TO_GITHUB}
variable "branch" { # export TF_VAR_branch=master
  type = string
  default = "master"
}


provider "aws" {
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

module "dev" {
  source = "../"

  providers = {
    aws = aws,
    aws.us-east-1 = aws.us-east-1
  }

  route53_id = var.route53_id
  route53_name = var.route53_name

  aws_account_id = var.aws_account_id
  codebuild_artifact_s3_bucket = var.codebuild_artifact_s3_bucket
  aws_code_connection_id_to_github = var.aws_code_connection_id_to_github
  branch = var.branch
}

# output "cloudfront_hosted_zone_id" {
#   value = module.dev.cloudfront_hosted_zone_id
# }
