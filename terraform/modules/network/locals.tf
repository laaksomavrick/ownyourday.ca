locals {
  everything_cidr_block = "0.0.0.0/0"
  vpc_cidr_block        = "10.0.0.0/16"

  # Given lb subnet is computed via AZs in region, this is used to compute 10, 11, 12, ...
  # e.g. 10.0.10.0/24, 10.0.11.0/24, ...
  lb_subnet_cidr_tertiary_block = 10

  app_server_cidr_block = "10.0.20.0/24"

  # Given db subnet is computed via AZs in region, this is used to compute 30, 31, 32, ...
  # e.g. 10.0.30.0/24, 10.0.31.0/24, ...
  db_subnet_cidr_tertiary_block = 30
}
