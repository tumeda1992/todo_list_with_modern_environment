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
  source = "../values"
}

module "alb" {
  source = "../../../../terraform/shared_abstract_modules/alb"

  service_name = module.values.service_name
  lb_target_port = module.values.service_port
  healthcheck_path = module.values.healthcheck_path
}

output "alb_dns_name" {
  value       = module.alb.alb_dns_name
}

output "alb_target_group_arn" {
  value       = module.alb.alb_target_group_arn
}

output "alb_security_group_id" {
  value       = module.alb.alb_security_group_id
}