module "bootstrap" {
  source = "../../bootstrap"
}

module "network" {
  source = "../"

  depends_on = [module.bootstrap]
}

output "vpc_id" {
  value       = module.network.vpc_id
}

# module "network2" {
#   source = "../"
#
#   depends_on = [module.bootstrap]
# }
#
# output "vpc_id2" {
#   value       = module.network2.vpc_id
# }

output "service_discovery_private_dns_namespace_id" {
  value       = module.network.service_discovery_private_dns_namespace_id
}