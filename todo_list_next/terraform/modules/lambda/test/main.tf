variable "ecr_repository_url" { type = string }

provider "aws" {
  region = "ap-northeast-1"
}

module "lambda" {
  source = "../"

  stage = "test"
  ecr_repository_url = var.ecr_repository_url
}
