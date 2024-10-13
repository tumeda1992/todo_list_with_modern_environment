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

output "service_name" {
  value = "${module.values.appname}-frontend"
}

output "service_port" {
  value = 30504
}

output "healthcheck_path" {
  value = "/api/healthcheck"
}