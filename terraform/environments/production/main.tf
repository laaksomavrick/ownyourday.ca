
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

  app_name                  = var.app_name
  image_uri                 = var.app_image_uri
  public_security_group_ids = [module.network.public_subnet_security_group_id]
  public_subnet_ids         = [module.network.public_subnet_id]
  public_ssh_key_file_path  = var.public_ssh_key_file_path

  db_username = var.db_username
  db_password = var.db_password
}

module "database" {
  source = "../../modules/database"

  environment = var.environment

  app_name          = var.app_name
  username          = var.db_username
  password          = var.db_password
  db_security_group = module.network.db_security_group
  db_subnet_group   = module.network.db_subnet_group
}

module "network" {
  source   = "../../modules/network"
  app_name = var.app_name
}
