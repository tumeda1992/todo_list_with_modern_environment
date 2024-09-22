variable "ecr_registry_name" { type = string }

provider "aws" {
  region = "ap-northeast-1"
}

module "network" {
  source = "../../network"
}

module "ecs" {
  source = "../"

  ecr_registry_name = var.ecr_registry_name
  vpc_id = module.network.vpc_id
  subnet_ids = module.network.subnet_ids
}

output "ecs_task_public_ip" {
  value = module.ecs.ecs_task_public_ip
}