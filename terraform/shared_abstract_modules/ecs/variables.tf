variable "service_name" { type = string }
variable "short_service_name" { type = string }
variable "docker_image_name" { type = string }
variable "application_port" { type = number }
variable "healthcheck_url" { type = string }
variable "subnet_ids" { type = list(string) }

variable "incoming_published_service_security_group_id" {
  type = string
  default = ""
}

variable "alb_target_group_arn" {
  type = string
  default = ""
}

variable "container_env_values" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "cpu_architecture" {
  type = string
  default = "ARM64"
}

variable "total_cpu" {
  type = string
  default = "512"
}

variable "total_memory" {
  type = string
  default = "1024"
}

variable "cpu_per_task" {
  type = number
  default = 512
}

variable "memory_per_task" {
  type = number
  default = 1024
}

variable "need_displaying_ecs_task_public_ip" {
  type    = bool
  default = true
}