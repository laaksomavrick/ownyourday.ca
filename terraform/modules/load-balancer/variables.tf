variable "app_name" {
  type = string
}

variable "lb_subnet_ids" {
  description = ""
  type        = list(string)
}

variable "lb_security_group_ids" {
  description = ""
  type        = list(string)
}

variable "app_server_cidr_block" {
  description = ""
  type        = string
}

variable "app_vpc_id" {
  type = string
}