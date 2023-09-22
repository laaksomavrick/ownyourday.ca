
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

module "network" {
  source   = "../../modules/network"
  app_name = var.app_name
}

module "dns" {
  source = "../../modules/dns"

  alb_dns_name = module.load-balancer.alb_dns_name
  alb_zone_id  = module.load-balancer.alb_zone_id
}

module "load-balancer" {
  source   = "../../modules/load-balancer"
  app_name = var.app_name

  ssl_certificate_arn = module.dns.ssl_certificate_arn

  app_server_cidr_block = module.network.app_server_cidr_block
  app_vpc_id            = module.network.vpc_id
  lb_security_group_ids = [module.network.lb_security_group_id]
  lb_subnet_ids         = module.network.lb_subnet_ids
}

module "app-server" {
  source = "../../modules/app-server"

  app_name                      = var.app_name
  app_image_repo                = var.app_image_repo
  app_image_version             = var.app_image_version
  app_server_security_group_ids = [module.network.app_server_security_group_id]
  app_server_subnet_ids         = [module.network.app_server_subnet_id]
  public_ssh_key_file_path      = var.public_ssh_key_file_path

  target_group_arn = module.load-balancer.target_group_arn

  db_host     = module.database.db_host
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

module "alarms" {
  source = "../../modules/alarms"

  app_name          = var.app_name
  error_event_email = var.error_event_email
  log_group_name    = module.app-server.log_group_name
}
