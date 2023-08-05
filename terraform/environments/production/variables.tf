variable "app_image_uri" {
  type = string
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

variable "app_name" {
  type    = string
  default = "ownyourday"
}

variable "environment" {
  type    = string
  default = "production"
}

