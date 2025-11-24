variable "ecr_repository_url" { type = string }
# variable "codebuild_artifact_s3_bucket" { type = string }
variable "aws_account_id" { type = string }
variable "aws_code_connection_id_to_github" { type = string }
variable "branch" {
  type = string
  default = "master"
}

provider "aws" {
  region = "ap-northeast-1"
}

module "codebuild" {
  source = "../"

  stage = "test"
  ecr_repository_url = var.ecr_repository_url
  lambda_function_name = "todo_app_front_lambda_test_managed_by_terraform"
  codebuild_artifact_s3_bucket = "codepipeline-ap-northeast-1-291883380577"
  aws_code_connection_github_arn = "arn:aws:codeconnections:ap-northeast-1:${var.aws_account_id}:connection/${var.aws_code_connection_id_to_github}"
  branch = var.branch
}
