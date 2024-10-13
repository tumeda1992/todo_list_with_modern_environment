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
  value = "${module.values.appname}-backend"
}

output "service_port" {
  value = 30418
}

output "healthcheck_path" {
  value = "/healthcheck"
}