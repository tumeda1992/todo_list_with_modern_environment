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

resource "aws_vpc" "new_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = module.values.vpc_name
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.new_vpc.id

  tags = {
    Name = "main-igw"
  }
}