variable "stage" { type = string }
variable "ecr_repository_url" { type = string }
variable "lambda_function_name" { type = string }
variable "codebuild_artifact_s3_bucket" { type = string }

resource "aws_codebuild_project" "codebuild_project" {
  name         = "todolist-frontend-build-${var.stage}-created-by-terraform"
  service_role = aws_iam_role.codebuild_role.arn

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true  # Docker 使用時は必要

    environment_variable {
      name  = "ECR_REPO_URI"
      value = var.ecr_repository_url
    }
    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }

    environment_variable {
      name  = "LAMBDA_FUNCTION_NAME"
      value = var.lambda_function_name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "todo_list_next/terraform/modules/codebuild/buildspec.yml"
  }

  artifacts {
    type     = "CODEPIPELINE"
    location = var.codebuild_artifact_s3_bucket
  }
}

resource "aws_iam_role" "codebuild_role" {
  name = "todolist-frontend-${var.stage}-codebuild-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "codebuild.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_ecr_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy" "codebuild_log_policy" {
  name = "todolist-frontend-codebuild-${var.stage}-cloudwatch-log-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy" "codebuild_s3_policy" {
  name = "todolist-frontend-codebuild-${var.stage}-s3-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketLocation",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.codebuild_artifact_s3_bucket}",
          "arn:aws:s3:::${var.codebuild_artifact_s3_bucket}/*"
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy" "codebuild_lambda_policy" {
  name = "todolist-frontend-codebuild-${var.stage}-lambda-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:UpdateFunctionCode",
          "lambda:GetFunction"
        ]
        Resource = "*"
      }
    ]
  })
}

output "codebuild_project_name" {
  value = aws_codebuild_project.codebuild_project.name
}
