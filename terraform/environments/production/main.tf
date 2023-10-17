
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

  alb_dns_name = module.load-balancer.alb_dns_name
  alb_zone_id  = module.load-balancer.alb_zone_id
  domain_name  = var.domain_name
}

module "load-balancer" {
  source   = "../../modules/load-balancer"
  app_name = var.app_name
  key_name = aws_key_pair.deployer.key_name

  ssl_certificate_arn = module.dns.ssl_certificate_arn

  reverse_proxy_security_group_ids = [module.network.nginx_security_group_id]

  app_server_cidr_block = module.network.app_server_cidr_block
  app_vpc_id            = module.network.vpc_id
  lb_security_group_ids = [module.network.lb_security_group_id]
  lb_subnet_ids         = module.network.lb_subnet_ids
  lb_subnet_id          = module.network.lb_subnet_id

  reverse_proxy_subnet_id = module.network.lb_subnet_ids.0
}

module "app-server" {
  source = "../../modules/app-server"

  app_name                      = var.app_name
  app_image_repo                = var.app_image_repo
  app_image_version             = var.app_image_version
  app_server_security_group_ids = [module.network.app_server_security_group_id]
  app_server_subnet_ids         = [module.network.app_server_subnet_id]
  key_name                      = aws_key_pair.deployer.key_name

  backend_security_group_ids = [module.network.app_server_security_group_id]
  backend_subnet_id          = module.network.app_server_subnet_id

  target_group_arn    = module.load-balancer.target_group_arn
  cloudfront_endpoint = module.cdn.cloudfront_endpoint

  new_relic_license_key = var.new_relic_license_key
  new_relic_api_key     = var.new_relic_api_key
  new_relic_account_id  = var.new_relic_account_id

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

module "metrics" {
  source = "../../modules/metrics"

  app_name                 = var.app_name
  cluster_name             = module.app-server.cluster_name
  target_group_arn_suffix  = module.load-balancer.target_group_arn_suffix
  load_balancer_arn_suffix = module.load-balancer.load_balancer_arn_suffix
  db_identifier            = module.database.db_identifier
}
