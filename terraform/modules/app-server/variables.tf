variable "app_name" {
  type = string
}

variable "app_image_repo" {
  type = string
}

variable "app_image_version" {
  type = string
}

variable "app_server_subnet_ids" {
  description = ""
  type        = list(string)
}

variable "app_server_security_group_ids" {
  description = ""
  type        = list(string)
}

variable "key_name" {
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

variable "container_port" {
  type    = number
  default = 3000
}

variable "cloudfront_endpoint" {
  type = string
}

variable "domain_name" {
  type    = string
  default = "ownyourday.ca"
}

variable "new_relic_license_key" {
  type = string
}

variable "new_relic_api_key" {
  type = string
}

variable "new_relic_account_id" {
  type = number
}

variable "backend_security_group_ids" {
  type = list(string)
}

variable "backend_subnet_id" {
  type = string
}

