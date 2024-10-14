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

module "global_network_values" {
  source = "../../../../terraform/global/network/modules/"
}

locals {
  short_service_name = "backend"
}

output "service_name" {
  value = "${module.values.appname}-${local.short_service_name}"
}

output "service_port" {
  value = 30418
}

output "healthcheck_path" {
  value = "/healthcheck"
}

output "short_service_name" {
  value = local.short_service_name
}

output "backend_host" {
  value = "${local.short_service_name}.${module.values.internal_host_suffix}"
}
