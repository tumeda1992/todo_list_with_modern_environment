variable "ecr_registry_name" { type = string }
variable "subnet_ids" { type = list(string) }

terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "ecs" {
  source = "../../../../terraform/shared_abstruct_modules/ecs"

  ecr_registry_name = var.ecr_registry_name
  subnet_ids = var.subnet_ids
}

output "ecs_task_public_ip" {
  value = module.ecs.ecs_task_public_ip
}