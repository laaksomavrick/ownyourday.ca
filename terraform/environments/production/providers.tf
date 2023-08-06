provider "aws" {
  region = "ca-central-1"

  # TODO: assume role for administering this stack

  default_tags {
    tags = {
      Environment = var.environment
      Project     = "ownyourday"
    }
  }
}
