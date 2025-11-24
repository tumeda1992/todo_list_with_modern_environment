# variable "ecr_registry_name" { type = string }
variable "route53_id" { type = string } # export TF_VAR_route53_id=${ROUTE53_HOSTZONE_ID}
variable "route53_name" { type = string } # export TF_VAR_route53_name=${ROUTE53_HOSTZONE_NAME}
variable "aws_account_id" { type = string }
variable "codebuild_artifact_s3_bucket" { type = string }
variable "aws_code_connection_id_to_github" { type = string }
variable "branch" {
  type = string
  default = "master"
}

terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  stage = "dev"
}

module "ecr" {
  source = "../../modules/ecr"
  stage = local.stage
}

module "lambda" {
  source = "../../modules/lambda"
  stage = local.stage
  ecr_repository_url = module.ecr.repository_url
}

module "apigateway" {
  source = "../../modules/apigateway"

  stage = local.stage
  lambda_function_arn = module.lambda.lambda_function_arn
}

module "cloudfront" {
  source = "../../modules/cloudfront"

  providers = {
    aws = aws,
    aws.us-east-1 = aws.us-east-1
  }

  api_endpoint = module.apigateway.api_endpoint
  custom_domain = "todolist-frontend-cdn-by-terraform.${var.route53_name}"
  route53_id = var.route53_id
  route53_name = var.route53_name
}

module "cicd" {
  source = "../../modules/cicd"

  stage = local.stage
  aws_account_id = var.aws_account_id
  ecr_repository_url = module.ecr.repository_url
  lambda_function_name = module.lambda.lambda_function_name
  codebuild_artifact_s3_bucket = var.codebuild_artifact_s3_bucket
  aws_code_connection_id_to_github = var.aws_code_connection_id_to_github
  branch = var.branch
}

# output "cloudfront_hosted_zone_id" {
#   value = module.cloudfront.cloudfront_hosted_zone_id
# }
