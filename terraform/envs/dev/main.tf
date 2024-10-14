variable "ecr_registry_name" { type = string }

provider "aws" {
  region = "ap-northeast-1"
}

module "global_bootstrap" {
  source = "../../global"
}

module "frontend" {
  source = "../../../todo_list_next/terraform/env_modules/dev"
  depends_on = [module.global_bootstrap]

  ecr_registry_name = var.ecr_registry_name
}

module "backend" {
  source = "../../../todo_list_application/terraform/env_modules/dev"
  depends_on = [module.global_bootstrap]

  ecr_registry_name = var.ecr_registry_name
  incoming_published_service_security_group_id = module.frontend.ecs_security_group_id
}

