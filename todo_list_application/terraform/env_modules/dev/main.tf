variable "ecr_registry_name" { type = string }

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
}
