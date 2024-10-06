variable "ecr_registry_name" { type = string }

variable "skip_displaying_ip" {
  type = bool
  default = false
}

provider "aws" {
  region = "ap-northeast-1"
}

module "global_bootstrap" {
  source = "../../global"
}

module "backend" {
  source = "../../../todo_list_application/terraform/env_modules/dev"
  depends_on = [module.global_bootstrap]

  ecr_registry_name = var.ecr_registry_name
  skip_displaying_ip = var.skip_displaying_ip
}

module "frontend" {
  source = "../../../todo_list_next/terraform/env_modules/dev"
  depends_on = [module.global_bootstrap]

  ecr_registry_name = var.ecr_registry_name
  skip_displaying_ip = var.skip_displaying_ip
}

