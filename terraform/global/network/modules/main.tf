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

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = [module.values.private_subnet_an1a_name]
  }
}

# 本来的には1つしか立ち上がらないはずだけど、誤って2回呼んでしまった場合にdestroyでエラーが起きるから複数対応している
output "vpc_id" {
  value = data.aws_vpcs.main.ids[0]
}

output "public_subnet_id" {
  value       = data.aws_subnets.public.ids[0]
}

output "private_subnet_id" {
  value       = data.aws_subnets.private.ids[0]
}

