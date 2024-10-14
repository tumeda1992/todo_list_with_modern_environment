terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "values" {
  source = "../../../../terraform/global/values"
}

locals {
  short_service_name = "frontend"
}

output "service_name" {
  value = "${module.values.appname}-${local.short_service_name}"
}

output "service_port" {
  value = 30504
}

output "healthcheck_path" {
  value = "/api/healthcheck"
}

output "short_service_name" {
  value = local.short_service_name
}