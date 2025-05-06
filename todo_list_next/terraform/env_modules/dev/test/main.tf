# variable "ecr_registry_name" { type = string }
variable "route53_id" { type = string } # export TF_VAR_route53_id=${ROUTE53_HOSTZONE_ID}
variable "route53_name" { type = string } # export TF_VAR_route53_name=${ROUTE53_HOSTZONE_NAME}


provider "aws" {
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

# module "global_bootstrap" {
#   source = "../../../../../terraform/global"
# }

module "dev" {
  source = "../"

  providers = {
    aws = aws,
    aws.us-east-1 = aws.us-east-1
  }

  route53_id = var.route53_id
  route53_name = var.route53_name

#   depends_on = [module.global_bootstrap]

#   ecr_registry_name = var.ecr_registry_name
}

# output "cloudfront_hosted_zone_id" {
#   value = module.dev.cloudfront_hosted_zone_id
# }
