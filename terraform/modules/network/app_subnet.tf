resource "aws_subnet" "app_subnet" {
  count             = length(data.aws_availability_zones.vpc_link_enabled.names)
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.0.${length(data.aws_availability_zones.vpc_link_enabled.names) + count.index + local.app_subnet_cidr_tertiary_block}.0/24"
  availability_zone = element(data.aws_availability_zones.vpc_link_enabled.names, count.index)

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-apigw_subnet-${element(data.aws_availability_zones.vpc_link_enabled.names, count.index)}"
  }
}

resource "aws_route_table" "app_route_table" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = local.everything_cidr_block
    gateway_id = aws_internet_gateway.app_gw.id
  }
}

resource "aws_route_table_association" "app_route_table_association-a" {
  subnet_id      = aws_subnet.app_subnet.0.id
  route_table_id = aws_route_table.app_route_table.id
}

resource "aws_route_table_association" "app_route_table_association-b" {
  subnet_id      = aws_subnet.app_subnet.1.id
  route_table_id = aws_route_table.app_route_table.id
}

resource "aws_security_group" "vpc_link_security_group" {
  vpc_id = aws_vpc.app_vpc.id

#  ingress {
#    description = ""
#    from_port   = 80
#    to_port     = 80
#    protocol    = "tcp"
#    cidr_blocks = [local.everything_cidr_block]
#  }
#
#  ingress {
#    from_port   = 443
#    to_port     = 443
#    protocol    = "tcp"
#    cidr_blocks = [local.everything_cidr_block]
#  }

}

resource "aws_security_group" "ecs_security_group" {
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    description = ""
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.vpc_link_security_group.id]
  }

#  ingress {
#    description = ""
#    from_port   = 1024
#    to_port     = 65535
#    protocol    = "tcp"
#    cidr_blocks = [local.everything_cidr_block]
#  }
#
#  ingress {
#    description = ""
#    from_port   = 80
#    to_port     = 80
#    protocol    = "tcp"
#    cidr_blocks = [local.everything_cidr_block]
#  }
#
#  ingress {
#    from_port   = 443
#    to_port     = 443
#    protocol    = "tcp"
#    cidr_blocks = [local.everything_cidr_block]
#  }
#
  ingress {
    description = ""
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.everything_cidr_block]
  }
#
#  egress {
#    description = ""
#    from_port   = 80
#    to_port     = 80
#    protocol    = "tcp"
#    cidr_blocks = [local.everything_cidr_block]
#  }
#
#  egress {
#    from_port   = 443
#    to_port     = 443
#    protocol    = "tcp"
#    cidr_blocks = [local.everything_cidr_block]
#  }
#
#  egress {
#    from_port   = 5432
#    to_port     = 5432
#    protocol    = "tcp"
#    cidr_blocks = [local.everything_cidr_block]
#  }
#
#  egress {
#    description = ""
#    from_port   = 1024
#    to_port     = 65535
#    protocol    = "tcp"
#    cidr_blocks = [local.everything_cidr_block]
#  }

  lifecycle {
    create_before_destroy = true
  }

}
