variable "stage" { type = string }
variable "ecr_repository_url" { type = string }

locals {
  lambda_function_name = "todo_app_front_lambda_${var.stage}_managed_by_terraform"
}

resource "aws_iam_role" "exec" {
  name = "${local.lambda_function_name}-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "basic" {
  role       = aws_iam_role.exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "this" {
  function_name = local.lambda_function_name
  package_type  = "Image"
  image_uri     = "${var.ecr_repository_url}:latest"
  role          = aws_iam_role.exec.arn

  memory_size = 1024
  timeout     = 30

  environment {
    variables = {
      AWS_LWA_INVOKE_MODE   = "response_stream"
      NEXT_PUBLIC_BACKEND_API_ORIGIN    = "https://7altwwfp36i5lr7hqwzicxhbbi0iaurn.lambda-url.ap-northeast-1.on.aws/api"
      PORT   = 8080
    }
  }
}

resource "aws_lambda_function_url" "this" {
  function_name       = aws_lambda_function.this.function_name
  authorization_type  = "NONE"
}

output "lambda_function_arn" {
  value       = aws_lambda_function.this.arn
}

output "lambda_invoke_arn" {
  value       = aws_lambda_function.this.invoke_arn
}
