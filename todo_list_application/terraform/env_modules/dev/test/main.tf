variable "ecr_registry_name" { type = string }

provider "aws" {
  region = "ap-northeast-1"
}

module "dev" {
  source = "../"

  ecr_registry_name = var.ecr_registry_name
}

