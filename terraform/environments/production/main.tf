
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket = "ownyourday-terraform-states"
    key    = "production.tfstate"
    region = "ca-central-1"
  }

  required_version = ">= 1.2.0"
}

module "app-server" {
  source = "../../modules/app-server"

  app_name                  = "ownyourday"
  public_security_group_ids = [module.network.public_subnet_security_group_id]
  public_subnet_ids         = [module.network.public_subnet_id]
}

module "network" {
  source = "../../modules/network"
}
