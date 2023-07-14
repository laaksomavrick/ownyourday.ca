resource "aws_vpc" "app_vpc" {
  cidr_block = local.vpc_cidr_block
}

resource "aws_internet_gateway" "app_gw" {
  vpc_id = aws_vpc.app_vpc.id
}
