provider "aws" {
  region = "ap-northeast-1"
}

module "global_bootstrap" {
  source = "../../../../../terraform/global"
}

module "values" {
  source = "../../../../../terraform/global/values"
}

module "alb" {
  source = "../"
  depends_on = [module.global_bootstrap]

  service_name = module.values.appname
  lb_target_port = 80
}

output "alb_dns_name" {
  value       = module.alb.alb_dns_name
}

output "alb_target_group_arn" {
  value       = module.alb.alb_target_group_arn
}