terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

output "vpc_name" {
  value = "todolist-vpc"
}

output "igw_name" {
  value = "todolist-igw"
}