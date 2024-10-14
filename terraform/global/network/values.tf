terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "global_values" {
  source = "../values"
}

output "vpc_name" {
  value = "${module.global_values.appname}-vpc"
}

output "igw_name" {
  value = "${module.global_values.appname}-igw"
}

output "public_subnet_an1a_name" {
  value = "${module.global_values.appname}-public-an1a-subnet"
}

output "public_subnet_an1c_name" {
  value = "${module.global_values.appname}-public-an1c-subnet"
}

output "private_subnet_an1a_name" {
  value = "${module.global_values.appname}-private-an1a-subnet"
}

output "private_subnet_an1c_name" {
  value = "${module.global_values.appname}-private-an1c-subnet"
}

output "public_route_table_name" {
  value = "${module.global_values.appname}-public-route-table"
}

output "private_route_table_name" {
  value = "${module.global_values.appname}-private-route-table"
}

output "service_discovery_private_dns_namespace_name" {
  value = module.global_values.internal_host_suffix
}