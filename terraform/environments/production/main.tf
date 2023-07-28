
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

#module "app-server" {
#  source = "../../modules/app-server"
#
#  app_name                  = "ownyourday"
#  image_uri = "844544735981.dkr.ecr.ca-central-1.amazonaws.com/ownyourday:55986ea100b8cb6cfd6a926f5861251c8c4c7d94" # TODO: variable
#  public_security_group_ids = [module.network.public_subnet_security_group_id]
#  public_subnet_ids         = [module.network.public_subnet_id]
#  public_key_file_path      = "~/.ssh/aws_ownyourday.pub"
#}

module "network" {
  source = "../../modules/network"
}
