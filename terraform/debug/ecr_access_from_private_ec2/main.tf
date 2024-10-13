variable "key_pair_name" { type = string }

provider "aws" {
  region = "ap-northeast-1"
}

module "global_network" {
  source = "../../global/network/modules"
}

# セキュリティグループ (踏み台ホスト)
resource "aws_security_group" "jump_sg" {
  vpc_id = module.global_network.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "jump-sg"
  }
}

# セキュリティグループ (プライベートEC2)
resource "aws_security_group" "private_sg" {
  vpc_id = module.global_network.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.jump_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-sg"
  }
}

# 踏み台ホスト (パブリックサブネット)
resource "aws_instance" "jump_host" {
  ami           = "ami-0ef29ab52ff72213b"
  instance_type = "t2.micro"
  subnet_id     = module.global_network.public_subnet_id
  security_groups = [aws_security_group.jump_sg.id]

  key_name = var.key_pair_name

  associate_public_ip_address = true

  tags = {
    Name = "jump-host"
  }
}

# プライベートサブネットのEC2インスタンス
resource "aws_instance" "private_instance" {
  ami           = "ami-0ef29ab52ff72213b"
  instance_type = "t2.micro"
  subnet_id     = module.global_network.private_subnet_id
  security_groups = [aws_security_group.private_sg.id]

  # ec2に鍵を仕込むのが面倒なのでパスワード式に
  user_data = <<-EOF
    #!/bin/bash
    echo 'ec2-user:passworddddddddd' | chpasswd
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    service sshd restart
    sudo yum install docker -y
    sudo service docker start
    sudo usermod -a -G docker ec2-user
  EOF

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  tags = {
    Name = "private-instance"
  }
}

# EC2用IAMロールの作成
resource "aws_iam_role" "ec2_role" {
  name = "ec2-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# ECRとS3へのアクセス権限を付与するポリシー
resource "aws_iam_policy" "ec2_ecr_s3_policy" {
  name        = "ec2-ecr-s3-policy"
  description = "Policy for EC2 to access ECR and S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetAuthorizationToken"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# IAMロールにポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "ec2_role_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_ecr_s3_policy.arn
}


resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}
