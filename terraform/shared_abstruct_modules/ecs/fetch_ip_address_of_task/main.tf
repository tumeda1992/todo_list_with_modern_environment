variable "ecs_cluster_id" { type = string }
variable "ecs_service_name" { type = string }

terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "null_resource" "wait_for_task_running" {
  provisioner "local-exec" {
    command = <<EOT
      task_arn=$(aws ecs list-tasks --cluster ${var.ecs_cluster_id} --service-name ${var.ecs_service_name} --query "taskArns[0]" --output text)
      while [ -z "$task_arn" ] || [ "$task_arn" == "None" ]; do
        echo "Waiting for ECS task to be created..."
        sleep 10
        task_arn=$(aws ecs list-tasks --cluster ${var.ecs_cluster_id} --service-name ${var.ecs_service_name} --query "taskArns[0]" --output text)
      done
      echo "ECS Task ARN: $task_arn"

      # タスクがRUNNING状態になるまで待機
      status=$(aws ecs describe-tasks --cluster ${var.ecs_cluster_id} --tasks $task_arn --query "tasks[0].lastStatus" --output text)
      while [ "$status" != "RUNNING" ]; do
        echo "Waiting for ECS task to be RUNNING..."
        sleep 10
        status=$(aws ecs describe-tasks --cluster ${var.ecs_cluster_id} --tasks $task_arn --query "tasks[0].lastStatus" --output text)
      done
      echo "ECS Task is RUNNING."
    EOT
  }
}

# externalデータソースでスクリプトを実行し、パブリックIPを取得
data "external" "fetch_eni_public_ip" {
  program = ["bash", "${path.module}/get_eni_public_ip.sh", var.ecs_cluster_id, var.ecs_service_name]
  depends_on = [null_resource.wait_for_task_running]
}

# パブリックIPの出力
output "ecs_task_public_ip" {
  value = data.external.fetch_eni_public_ip.result["public_ip"]
}