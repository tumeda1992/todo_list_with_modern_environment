variable "ecr_registry_name" { type = string }

variable "skip_displaying_ip" {
  type = bool
  default = false
}

provider "aws" {
  region = "ap-northeast-1"
}

module "global_bootstrap" {
  source = "../../../../../terraform/global"
}

module "ecs" {
  source = "../"
  depends_on = [module.global_bootstrap]

  ecr_registry_name = var.ecr_registry_name
  skip_displaying_ip = var.skip_displaying_ip
}

output "ecs_task_public_ip" {
  value = module.ecs.ecs_task_public_ip
}