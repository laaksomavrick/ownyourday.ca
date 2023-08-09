locals {
  everything_cidr_block = "0.0.0.0/0"
  vpc_cidr_block        = "10.0.0.0/16"

  load_balancer_cidr_block = "10.0.10.0/24"
  app_server_cidr_block    = "10.0.20.0/24"

  # Given db subnet is computed via AZs in region, this is used to compute 30, 31, 32, ...
  # e.g. 10.0.30.0/24, 10.0.31.0/24, ...
  db_subnet_cidr_tertiary_block = 30
}
