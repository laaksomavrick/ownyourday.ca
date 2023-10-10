variable "app_image_repo" {
  type = string
}

variable "app_image_version" {
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

variable "error_event_email" {
  type = string
}

variable "domain_name" {
  type    = string
  default = "ownyourday.ca"
}
