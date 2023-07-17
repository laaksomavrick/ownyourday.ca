variable "app_name" {
  type = string
}

//variable "image_uri" {
//  description = "The URI of the image to run in the task definition"
//  type = string
//}

variable "public_subnet_ids" {
  description = ""
  type        = list(string)
}

variable "public_security_group_ids" {
  description = ""
  type        = list(string)
}

variable "public_key_file_path" {
  type = string
}
