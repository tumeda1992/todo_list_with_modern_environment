provider "aws" {
  region = "ap-northeast-1"
}

# 起動・停止ともに5分くらいかかる
module "cloudfront" {
  source = "../"

#   stage = "test"
  api_endpoint = "https://acyidtk5sg.execute-api.ap-northeast-1.amazonaws.com"
}
