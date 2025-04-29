variable "ecr_registry_name" { type = string }

provider "aws" {
  region = "ap-northeast-1"
}

module "lambda" {
  source = "../"

  stage = "test"
  ecr_repository_url = "${var.ecr_registry_name}/todo_app/front/lambda/managed_by_terraform/dev"
}
