variable "app_name" {
  type = string
}

variable "ssl_certificate_arn" {
  type = string
}

variable "domain_name" {
  type    = string
  default = "ownyourday.ca"
}

variable "vpc_link_security_group_ids" {
  description = ""
  type        = list(string)
}

variable "app_subnet_ids" {
  description = ""
  type        = list(string)
}

variable "cloudmap_service_arn" {
  type = string
}
