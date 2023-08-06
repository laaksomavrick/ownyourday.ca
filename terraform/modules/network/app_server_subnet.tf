resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = local.public_subnet_cidr_block
  map_public_ip_on_launch = true
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = local.everything_cidr_block
    gateway_id = aws_internet_gateway.app_gw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "public_subnet_security_group" {
  vpc_id = aws_vpc.app_vpc.id

  # TODO: remove when we refactor to use a load balancer
  ingress {
    description = ""
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.everything_cidr_block]
  }

  # TODO: remove when we refactor to use a load balancer
  ingress {
    description = ""
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.everything_cidr_block]
  }

  ingress {
    description = ""
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.everything_cidr_block]
  }

  ingress {
    description = ""
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [local.everything_cidr_block]
  }

  # TODO: can this be locked down more?
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.everything_cidr_block]
  }

  lifecycle {
    create_before_destroy = true
  }

}

