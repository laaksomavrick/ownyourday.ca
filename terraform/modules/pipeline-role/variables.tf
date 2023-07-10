variable "github_repo_path" {
  type = string
  description = "URL to the Github repository the pipeline role will have access to"
}

variable "container_registry_arn" {
  type = string
  description = "The ARN of the container registry images will be uploaded to"
}
