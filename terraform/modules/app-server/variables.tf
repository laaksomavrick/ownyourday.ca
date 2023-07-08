variable "common_tags" {
  description = "Common tags you want applied to all infrastructure components"
  type = object({
    Project     = string
    Environment = string
  })

  validation {
    condition     = var.common_tags["Environment"] == "production" || var.common_tags["Environment"] == "staging"
    error_message = "Environment must be either 'staging' or 'production'"
  }

  # TODO: how to make this as a default value instead of being set from callers?
  validation {
    condition     = var.common_tags["Project"] == "ownyourday"
    error_message = "Project must be 'ownyourday'"
  }
}
