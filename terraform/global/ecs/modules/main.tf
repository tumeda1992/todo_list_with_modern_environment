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
  source = "../"
}

data "aws_ecs_cluster" "main" {
  cluster_name = module.values.cluster_name
}

data "aws_iam_role" "ecs_task_execution" {
  name = module.values.ecs_task_execution_iam_role_name
}

output "ecs_cluster_id" {
  value = data.aws_ecs_cluster.main.id
}

output "ecs_task_execution_iam_role_arn" {
  value = data.aws_iam_role.ecs_task_execution.arn
}

# コメントアウト理由はcheck_resource_status.pyに記載
# （ecs_clusterはうまく行ったがvpcがうまく行かなかったので一律bootstrap式へ）

# locals {
#   cluster_name = "fargate-cluster"
# #   cluster_name = "sample_todo_list_cluster"
# }
#
# # クラスタの状態を確認
# data "external" "check_cluster_status" {
#   program = ["python3", "${path.module}/../check_resource_status.py"]
#   query = {
#     resource_name = local.cluster_name
#     resource_type = "ecs_cluster"
#   }
# }
#
# # クラスタがINACTIVEなら新規作成
# resource "aws_ecs_cluster" "new_cluster" {
#   count = data.external.check_cluster_status.result["status"] == "INACTIVE" ? 1 : 0
#   name  = local.cluster_name
# }
#
# data "aws_ecs_cluster" "existing_cluster" {
#   count = data.external.check_cluster_status.result["status"] == "ACTIVE" ? 1 : 0
#   cluster_name = local.cluster_name
# }
#
# output "ecs_cluster_id" {
#   value = data.external.check_cluster_status.result["status"] == "ACTIVE" ? data.aws_ecs_cluster.existing_cluster[0].id : aws_ecs_cluster.new_cluster[0].id
# }