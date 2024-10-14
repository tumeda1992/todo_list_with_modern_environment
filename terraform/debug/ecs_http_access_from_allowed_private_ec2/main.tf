provider "aws" {
  region = "ap-northeast-1"
}

locals {
  pass = "passworddddddddd"
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

  # ec2に鍵を仕込むのが面倒なのでパスワード式に
  user_data = <<-EOF
    #!/bin/bash
    echo 'ec2-user:${local.pass}' | chpasswd
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    service sshd restart
    sudo yum install docker -y
    sudo service docker start
    sudo usermod -a -G docker ec2-user
  EOF

  associate_public_ip_address = true

  tags = {
    Name = "jump-host"
  }
}

data "aws_security_group" "ecs-sg" {
  filter {
    name   = "tag:Name"
    values = ["todolist-frontend-ecs-service-sg"]
  }
}

# プライベートサブネットのEC2インスタンス
resource "aws_instance" "private_instance" {
  ami           = "ami-0ef29ab52ff72213b"
  instance_type = "t2.micro"
  subnet_id     = module.global_network.private_subnet_id
  security_groups = [aws_security_group.private_sg.id, data.aws_security_group.ecs-sg.id]

  # ec2に鍵を仕込むのが面倒なのでパスワード式に
  user_data = <<-EOF
    #!/bin/bash
    echo 'ec2-user:${local.pass}' | chpasswd
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    service sshd restart
    sudo yum install docker -y
    sudo service docker start
    sudo usermod -a -G docker ec2-user
  EOF

  tags = {
    Name = "private-instance"
  }
}

output "pass" {
  value = local.pass
}

output "public_ec2_access_command" {
  value = "ssh ec2-user@${aws_instance.jump_host.public_ip}"
}

output "private_ec2_access_command" {
  value = "ssh ec2-user@${aws_instance.private_instance.private_ip}"
}