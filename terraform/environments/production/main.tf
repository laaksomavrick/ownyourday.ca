
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

resource "aws_key_pair" "deployer" {
  key_name   = "${var.app_name}-ssh-key-pair"
  public_key = file(var.public_ssh_key_file_path)
}

module "network" {
  source   = "../../modules/network"
  app_name = var.app_name
}

module "dns" {
  source = "../../modules/dns"

  domain_name             = var.domain_name
  reverse_proxy_public_ip = module.load-balancer.reverse_proxy_public_ip
}

module "load-balancer" {
  source   = "../../modules/load-balancer"
  app_name = var.app_name
  key_name = aws_key_pair.deployer.key_name

  reverse_proxy_security_group_ids = [module.network.reverse_proxy_security_group_id]
  reverse_proxy_subnet_id          = module.network.reverse_proxy_subnet_id

  new_relic_license_key = var.new_relic_license_key
}

module "app-server" {
  source = "../../modules/app-server"

  app_name                      = var.app_name
  app_image_repo                = var.app_image_repo
  app_image_version             = var.app_image_version
  app_server_security_group_ids = [module.network.app_server_security_group_id]
  app_server_subnet_ids         = [module.network.app_server_subnet_id]
  key_name                      = aws_key_pair.deployer.key_name

  cloudmap_service_arn = module.network.cloudmap_service_arn

  cloudfront_endpoint = module.cdn.cloudfront_endpoint

  new_relic_license_key = var.new_relic_license_key
  new_relic_api_key     = var.new_relic_api_key
  new_relic_account_id  = var.new_relic_account_id

  db_host     = module.database.db_host
  db_username = var.db_username
  db_password = var.db_password

  bucket_arn  = module.storage.bucket_arn
  bucket_name = module.storage.bucket_name
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

module "storage" {
  source = "../../modules/storage"

  app_name = var.app_name
}

module "cdn" {
  source = "../../modules/cdn"

  app_name    = var.app_name
  domain_name = var.domain_name
}

module "alarms" {
  source = "../../modules/alarms"

  app_name          = var.app_name
  error_event_email = var.error_event_email
  log_group_name    = module.app-server.log_group_name
}
