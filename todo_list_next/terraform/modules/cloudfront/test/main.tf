variable "route53_id" { type = string } # export TF_VAR_route53_id=${ROUTE53_HOSTZONE_ID}
variable "route53_name" { type = string } # export TF_VAR_route53_name=${ROUTE53_HOSTZONE_NAME}

provider "aws" {
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "va"     # CloudFront 用の us-east-1 プロバイダー
  region = "us-east-1"
}

locals {
  custom_domain = "todolist-frontend-cdn-by-terraform.${var.route53_name}"
}

module "cert" {
  source = "../cert"
  providers = { aws = aws.va }

  custom_domain = local.custom_domain
  route53_zone_id = var.route53_id
}

# 起動・停止ともに5分くらいかかる
module "cloudfront" {
  source = "../"

#   stage = "test"
  api_endpoint = "https://acyidtk5sg.execute-api.ap-northeast-1.amazonaws.com"
  certificate_arn = module.cert.certificate_arn
  custom_domain = local.custom_domain
}

module "dns" {
  source = "../dns"

  custom_domain = local.custom_domain
  route53_zone_id = var.route53_id
  cf_domain_name = module.cloudfront.cloudfront_domain_name
  cf_zone_id = module.cloudfront.cloudfront_hosted_zone_id

#   depends_on = [module.cert]
}
