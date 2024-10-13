variable "ecr_registry_name" { type = string }

variable "skip_displaying_ip" {
  type = bool
  default = false
}

provider "aws" {
  region = "ap-northeast-1"
}

module "global_bootstrap" {
  source = "../../../../../terraform/global"
}

module "values" {
  source = "../../../modules/values"
}

module "alb" {
  source = "../../../../../terraform/shared_abstract_modules/alb"
  depends_on = [module.global_bootstrap]

  service_name = module.values.service_name
  lb_target_port = module.values.service_port
  healthcheck_path = module.values.healthcheck_path
}

module "dev" {
  source = "../"
  depends_on = [module.global_bootstrap]

  ecr_registry_name = var.ecr_registry_name
  incoming_published_service_security_group_id = module.alb.alb_security_group_id
  alb_target_group_arn = module.alb.alb_target_group_arn
}

output "root_url" {
  value = "http://${module.alb.alb_dns_name}"
}

output "backend_url" {
  value = "http://${module.alb.alb_dns_name}/healthcheck"
}

