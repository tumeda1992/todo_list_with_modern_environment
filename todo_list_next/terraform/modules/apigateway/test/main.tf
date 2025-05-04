variable "aws_account_id" { type = string }

provider "aws" {
  region = "ap-northeast-1"
}

module "apigateway" {
  source = "../"

  stage = "test"
  lambda_function_arn = "arn:aws:lambda:ap-northeast-1:${var.aws_account_id}:function:todo_app_front_lambda_dev_managed_by_terraform"
}
