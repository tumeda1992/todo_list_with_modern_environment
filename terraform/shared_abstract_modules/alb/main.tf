variable "service_name" { type = string }
variable "lb_target_port" { type = number }
variable "healthcheck_path" { type = string }

terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "values" {
  source = "../../global/values"
}

module "global_network" {
  source = "../../global/network/modules"
}

resource "aws_lb" "main" {
  name               = "${var.service_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [module.global_network.public_subnet_id, module.global_network.public_subnet_id2]
}

resource "aws_lb_target_group" "main" {
  name     = "${var.service_name}-lb-tg"
  port     = var.lb_target_port
  protocol = "HTTP"
  vpc_id   = module.global_network.vpc_id
  target_type = "ip"

  health_check {
    path                = var.healthcheck_path
    interval            = 30
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 3
    matcher             = "200"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_security_group" "alb_sg" {
  vpc_id = module.global_network.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "${var.service_name}-alb-sg"
  }
}

output "alb_dns_name" {
  value       = aws_lb.main.dns_name
}

output "alb_target_group_arn" {
  value       = aws_lb_target_group.main.arn
}

output "alb_security_group_id" {
  value       = aws_security_group.alb_sg.id
}