variable "app_name" {
  type = string
}

variable "cloudmap_service_arn" {
  type = string
}

variable "app_image_repo" {
  type = string
}

variable "app_image_version" {
  type = string
}

variable "app_subnet_ids" {
  description = ""
  type        = list(string)
}

variable "ecs_security_group_ids" {
  description = ""
  type        = list(string)
}

variable "public_ssh_key_file_path" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_host" {
  type = string
}

variable "container_port" {
  type    = number
  default = 3000
}
