provider "aws" {
  region = "ap-northeast-1"
}

module "ecr" {
  source = "../"

  stage = "test"
}

output "repository_url" {
  value = module.ecr.repository_url
}
