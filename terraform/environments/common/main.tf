
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket = "ownyourday-terraform-states"
    key    = "common.tfstate"
    region = "ca-central-1"
  }

  required_version = ">= 1.2.0"
}

module "container_registry" {
  source = "../../modules/container-registry"
}

module "pipeline_role" {
  source                 = "../../modules/pipeline-role"
  container_registry_arn = module.container_registry.container_registry_arn
  github_repo_path       = var.github_repo_path
}
