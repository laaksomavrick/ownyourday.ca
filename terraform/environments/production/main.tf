
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

  apigw_dns_name = module.api_gateway.apigw_dns_name
  apigw_zone_id  = module.api_gateway.apigw_zone_id
}

module "api_gateway" {
  source = "../../modules/api-gateway"

  app_name             = var.app_name
  cloudmap_service_arn = module.network.cloudmap_service_arn

  vpc_link_security_group_ids = [module.network.vpc_link_security_group_id]
  app_subnet_ids              = module.network.app_subnet_ids

  ssl_certificate_arn = module.dns.ssl_certificate_arn
}

module "app-server" {
  source = "../../modules/app-server"

  app_name                 = var.app_name
  app_image_repo           = var.app_image_repo
  app_image_version        = var.app_image_version
  ecs_security_group_ids   = [module.network.ecs_security_group_id]
  app_subnet_ids           = module.network.app_subnet_ids
  public_ssh_key_file_path = var.public_ssh_key_file_path
  container_port = 80

  cloudmap_service_arn = module.network.cloudmap_service_arn

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

#module "metrics" {
#  source = "../../modules/metrics"
#
#  app_name                 = var.app_name
#  cluster_name             = module.app-server.cluster_name
#  target_group_arn_suffix  = module.load-balancer.target_group_arn_suffix
#  load_balancer_arn_suffix = module.load-balancer.load_balancer_arn_suffix
#  db_identifier            = module.database.db_identifier
#}
