variable "ecr_registry_name" { type = string }

variable "incoming_published_service_security_group_id" {
  type = string
  default = ""
}

variable "alb_target_group_arn" {
  type = string
  default = ""
}

terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "global_network" {
  source = "../../../../terraform/global/network/modules"
}

module "ecs" {
  source = "../../modules/ecs"

  ecr_registry_name = var.ecr_registry_name
  incoming_published_service_security_group_id = var.incoming_published_service_security_group_id
  alb_target_group_arn = var.alb_target_group_arn
  skip_displaying_ip = true
}

output "ecs_dns" {
  value = module.ecs.ecs_host
}
