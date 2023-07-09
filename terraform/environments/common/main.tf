
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "ownyourday-terraform-states"
    key            = "common.tfstate"
    region         = "ca-central-1"
  }

  required_version = ">= 1.2.0"
}

module "container-registry" {
  source = "../../modules/container-registry"

  common_tags = {
    Project     = "ownyourday"
    Environment = "production"
  }
}
