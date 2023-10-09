locals {
  everything_cidr_block = "0.0.0.0/0"
  vpc_cidr_block        = "10.0.0.0/16"

  app_subnet_cidr_tertiary_block = 10
  db_subnet_cidr_tertiary_block  = 20
}
