variable "stage" { type = string }
variable "aws_account_id" { type = string }
variable "ecr_repository_url" { type = string }
variable "lambda_function_name" { type = string }
variable "codebuild_artifact_s3_bucket" { type = string }
variable "aws_code_connection_id_to_github" { type = string }
variable "branch" {
  type = string
  default = "master"
}

locals {
  aws_code_connection_github_arn = "arn:aws:codeconnections:ap-northeast-1:${var.aws_account_id}:connection/${var.aws_code_connection_id_to_github}"
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

resource "aws_iam_role_policy_attachment" "codebuild_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

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

resource "aws_codepipeline" "pipeline" {
  name     = "todolist_frontend_codepipeline-${var.stage}"
  role_arn = aws_iam_role.codepipeline_role.arn


  artifact_store {
    type     = "S3"
    location = var.codebuild_artifact_s3_bucket
  }

  stage {
    name = "Source"

    action {
      name      = "SourceAction"
      run_order = 1

      category = "Source"
      owner    = "AWS"
      provider = "CodeStarSourceConnection"
      version  = "1"

      configuration = {
        FullRepositoryId     = "tumeda1992/todo_list_with_modern_environment"
        BranchName           = var.branch
        ConnectionArn        = local.aws_code_connection_github_arn
        OutputArtifactFormat = "CODE_ZIP"
      }

      output_artifacts = ["source_output"]
    }
  }


  stage {
    name = "Build"
    action {
      name             = "BuildAction"
      run_order        = 2
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      configuration    = {
        "ProjectName" = aws_codebuild_project.codebuild_project.name
      }
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      role_arn         = aws_iam_role.codepipeline_role.arn
    }
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline-${var.stage}_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = { Service = "codepipeline.amazonaws.com" }
        Effect    = "Allow"
      }
    ]
  })
}

# CodePipeline の操作に必要な権限ポリシーを追加
resource "aws_iam_policy" "codepipeline_policy" {
  name        = "todolist_frontend_codepipeline-${var.stage}_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:CreateBucket"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "codebuild:BatchGetBuilds"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "codebuild:StartBuild"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "codecommit:GitPull"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "iam:PassRole"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          # 古い名前（今でも必要）
          "codestar-connections:UseConnection",
          # 新しい service 名に合わせたやつ（保険で両方）
          "codeconnections:UseConnection"
        ]
        Effect   = "Allow"
        Resource = local.aws_code_connection_github_arn
      }
    ]
  })
}

# IAM Role にポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "attach_policy_to_codepipeline" {
  policy_arn = aws_iam_policy.codepipeline_policy.arn
  role       = aws_iam_role.codepipeline_role.name
}

resource "aws_iam_role_policy" "codebuild_extra" {
  # TODO: 名前変えたい
  # TODO: stageごとにしたい
  # TODO: 小分けのロールにしたい
  name = "todolist-frontend-codebuild-${var.stage}-extra-policy"
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
        # 絞るなら /aws/codebuild/${aws_codebuild_project.codebuild_project.name} 配下だけにしてもOK
      },

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

