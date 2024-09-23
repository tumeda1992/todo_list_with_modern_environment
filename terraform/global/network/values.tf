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
  value = "main-igw"
}