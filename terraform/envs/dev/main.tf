variable "ecr_registry_name" { type = string }

provider "aws" {
  region = "ap-northeast-1"
}

module "backend" {
  source = "../../../todo_list_application/terraform/env_modules/dev"

  ecr_registry_name = var.ecr_registry_name
}

