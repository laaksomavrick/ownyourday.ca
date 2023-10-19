resource "aws_subnet" "reverse_proxy_subnet" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.0.${local.lb_subnet_cidr_tertiary_block}.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-reverse-proxy-subnet"
  }
}

resource "aws_route_table" "reverse_proxy_route_table" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = local.everything_cidr_block
    gateway_id = aws_internet_gateway.app_gw.id
  }
}

resource "aws_route_table_association" "load_balancer_route_table_association" {
  subnet_id      = aws_subnet.reverse_proxy_subnet.id
  route_table_id = aws_route_table.reverse_proxy_route_table.id
}

resource "aws_security_group" "reverse_proxy_security_group" {
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    description = ""
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.everything_cidr_block]
  }

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

  egress {
    description = ""
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.everything_cidr_block]
  }

  egress {
    description = ""
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.everything_cidr_block]
  }

  egress {
    description = ""
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [local.everything_cidr_block]
  }

  lifecycle {
    create_before_destroy = true
  }

}


