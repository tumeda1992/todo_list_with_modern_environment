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

module "values" {
  source = "../../../../terraform/global/values"
}

module "alb" {
  source = "../../modules/alb"

  service_name = module.values.appname
  healthcheck_path = "/api/healthcheck"
  lb_target_port = 30504
}

module "ecs" {
  source = "../../modules/ecs"

  ecr_registry_name = var.ecr_registry_name
  incoming_published_service_security_group_id = module.alb.alb_security_group_id
  alb_target_group_arn = module.alb.alb_target_group_arn
  skip_displaying_ip = true
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
