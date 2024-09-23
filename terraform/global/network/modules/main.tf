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

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [module.values.vpc_name]
  }
}

data "aws_internet_gateway" "main" {
  filter {
    name   = "tag:Name"
    values = [module.values.igw_name]
  }
}

output "vpc_id" {
  value = data.aws_vpc.main.id
}

output "igw_id" {
  value = data.aws_internet_gateway.main.id
}

