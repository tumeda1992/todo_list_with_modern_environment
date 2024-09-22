variable "ecr_registry_name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }

locals {
  application_port = 30418
}

terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_ecs_cluster" "main" {
  name = "fargate-cluster"
#   name = "sample_todo_list_cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "fargate-task"
#   family                   = "sample_todo_list"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"    # 1 vCPU
  memory                   = "1024"    # 512MB
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  runtime_platform {
    operating_system_family = "LINUX"                 # OSの設定 (LINUX)
    cpu_architecture        = "ARM64"                 # アーキテクチャの設定 (ARM64)
  }

  container_definitions = jsonencode([{
    name  = "backend_todo_app"
    image = "${var.ecr_registry_name}/todo_app_back:latest"
    essential = true
    portMappings = [{
      containerPort = local.application_port
      hostPort      = local.application_port
      protocol      = "tcp"
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/fargate-task"    # CloudWatch Logsのロググループ
        "awslogs-region"        = "ap-northeast-1"       # リージョン
        "awslogs-stream-prefix" = "ecs"                  # ストリームのプレフィックス
        "awslogs-create-group"  = "true"                 # ロググループの自動作成
        "mode"                  = "non-blocking"         # モード
        "max-buffer-size"       = "25m"                  # 最大バッファサイズ
      }
    }
    cpu    = 512   # このコンテナのCPU制限（vCPUの1/4）
    memory = 1024   # このコンテナのメモリ制限（512MB）
    healthCheck = {
      command     = ["CMD-SHELL", "curl -f http://localhost:30418/hello || exit 1"]
      interval    = 30  # ヘルスチェックの間隔（秒）
      timeout     = 5   # タイムアウト（秒）
      retries     = 3   # リトライ回数
      startPeriod = 60  # 起動後の初回ヘルスチェックまでの待機時間（秒）
    }
  }])
}

resource "aws_ecs_service" "app" {
  name            = "fargate-service"
#   name            = "sample_todo_list_service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_circuit_breaker {
    enable   = true   # サーキットブレーカーを有効化
    rollback = true   # 失敗時のロールバックを有効化
  }

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.main.id]
    assign_public_ip = true
  }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.main.arn
#     container_name   = "app"
#     container_port   = 80
#   }
#
#   depends_on = [
#     aws_lb_listener.main
#   ]
}

resource "aws_security_group" "main" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = local.application_port
    to_port     = local.application_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "main-sg"
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRoleeee"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_cloudwatch_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

