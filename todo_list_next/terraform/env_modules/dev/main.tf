variable "ecr_registry_name" { type = string }

variable "skip_displaying_ip" {
  type = bool
  default = false
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

module "ecs" {
  source = "../../modules/ecs"

  ecr_registry_name = var.ecr_registry_name
  skip_displaying_ip = var.skip_displaying_ip
}
