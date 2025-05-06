variable "api_endpoint" { type = string }
variable "custom_domain" { type = string }
variable "certificate_arn" { type = string }

resource "aws_cloudfront_distribution" "cf" {
  origin {
    # API Gateway のエンドポイントからスキームを除去して domain_name に指定
    domain_name = replace(
      replace(var.api_endpoint, "https://", ""),
      "http://", ""
    )
    origin_id   = "apiGatewayOrigin" # origin_idはディストリビューション内で一意であればいい

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }

#     # CloudFront のアクセスログを S3 に出力
#     logging_config {
#       bucket = "${var.logging_bucket}.s3.amazonaws.com"  # S3 バケット名（末尾に .s3.amazonaws.com を付与）
#       include_cookies = false
#       prefix          = "cf-logs/${var.custom_domain}/"
#     }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "todo-app CDN for front of Next.js on API Gateway CloudFront for API Gateway (domain-less)"

  default_cache_behavior {
    target_origin_id       = "apiGatewayOrigin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET","HEAD","OPTIONS","PUT","POST","PATCH","DELETE"]
    cached_methods         = ["GET","HEAD","OPTIONS"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"       # AWS Managed – CachingOptimized
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"   # AWS Managed – AllViewerExceptHostHeader
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

  aliases = [var.custom_domain]
}

output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.cf.domain_name
}

output "cloudfront_hosted_zone_id" {
  value       = aws_cloudfront_distribution.cf.hosted_zone_id
}
