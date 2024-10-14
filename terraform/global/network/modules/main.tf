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
  source = "../"
}

data "aws_vpcs" "main" {
  filter {
    name   = "tag:Name"
    values = [module.values.vpc_name]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = [module.values.public_subnet_an1a_name]
  }
}

data "aws_subnets" "public2" {
  filter {
    name   = "tag:Name"
    values = [module.values.public_subnet_an1c_name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = [module.values.private_subnet_an1a_name]
  }
}

data "aws_subnets" "private2" {
  filter {
    name   = "tag:Name"
    values = [module.values.private_subnet_an1c_name]
  }
}

data "aws_route_tables" "private_rt" {
  filter {
    name   = "tag:Name"
    values = [module.values.private_route_table_name]
  }
}

# 未対応
# data "aws_service_discovery_private_dns_namespace" "main" {
#   name = module.values.service_discovery_private_dns_namespace_name
# }
# brew install jqが必要
data "external" "namespace_id" {
  program = ["bash", "-c", <<EOT
    aws servicediscovery list-namespaces \
      --query 'Namespaces[?Name==`${module.values.service_discovery_private_dns_namespace_name}`].Id | [0]' \
      --output json | jq -n '{ result: input }'
  EOT
  ]
}

# 本来的には1つしか立ち上がらないはずだけど、誤って2回呼んでしまった場合にdestroyでエラーが起きるから複数対応している
output "vpc_id" {
  value = data.aws_vpcs.main.ids[0]
}

output "public_subnet_id" {
  value       = data.aws_subnets.public.ids[0]
}

output "public_subnet_id2" {
  value       = data.aws_subnets.public2.ids[0]
}

output "private_subnet_id" {
  value       = data.aws_subnets.private.ids[0]
}

output "private_subnet_id2" {
  value       = data.aws_subnets.private2.ids[0]
}

output "private_rt_id" {
  value       = data.aws_route_tables.private_rt.ids[0]
}

output "service_discovery_private_dns_namespace_id" {
  value       = data.external.namespace_id.result["result"]
}
