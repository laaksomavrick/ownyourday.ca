variable "app_name" {
  type = string
}

variable "image_uri" {
  description = "The URI of the image to run in the task definition"
  type        = string
}

variable "app_server_subnet_ids" {
  description = ""
  type        = list(string)
}

variable "app_server_security_group_ids" {
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

variable "target_group_arn" {
  type = string
}
