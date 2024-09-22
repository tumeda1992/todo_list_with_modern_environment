variable "ecr_registry_name" { type = string }

provider "aws" {
  region = "ap-northeast-1"
}

module "global_bootstrap" {
  source = "../../../../../terraform/global"
}

module "network" {
  source = "../../network"
  depends_on = [module.global_bootstrap]
}

module "ecs" {
  source = "../"
  depends_on = [module.global_bootstrap]

  ecr_registry_name = var.ecr_registry_name
  subnet_ids = module.network.subnet_ids
}

output "ecs_task_public_ip" {
  value = module.ecs.ecs_task_public_ip
}