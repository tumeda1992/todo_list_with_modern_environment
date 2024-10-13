terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "network" {
  source = "./network/bootstrap"
}

module "ecs" {
  source = "./ecs/bootstrap"
  depends_on = [module.network]
}

