variable "app_name" {
  type = string
}

variable "key_name" {
  type = string
}

variable "reverse_proxy_security_group_ids" {
  type = list(string)
}

variable "reverse_proxy_subnet_id" {
  type = string
}

variable "new_relic_license_key" {
  type = string
}
