terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "global_values" {
  source = "../values"
}

output "appname" {
  value = module.global_values.appname
}

output "cluster_name" {
  value = "${module.global_values.appname}_cluster"
}

output "ecs_task_execution_iam_role_name" {
  value = "ecsTaskExecutionRoleeee"
}