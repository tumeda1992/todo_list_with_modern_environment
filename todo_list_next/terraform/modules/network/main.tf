terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  vpc_id = module.network.vpc_id
}

module "network" {
  source = "../../../../terraform/global/network/modules"
}

# 一旦backendとサブネットを別に立てるけど、通信や合理性の観点からglobalに移して1つにしそう
resource "aws_subnet" "main" {
  vpc_id            = local.vpc_id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "todolist-frontend-subnet"
  }
}

resource "aws_route_table" "main" {
  vpc_id = local.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.network.igw_id
  }

  tags = {
    Name = "todolist-frontend-route-table"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

output "vpc_id" {
  value       = local.vpc_id
}

output "subnet_ids" {
  value       = [aws_subnet.main.id]
}