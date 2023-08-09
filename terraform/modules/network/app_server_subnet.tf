resource "aws_subnet" "app_server_subnet" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = local.app_server_cidr_block

  # TODO THIS SHOULDNT BE NECESSARY
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-app_server_subnet-1"
  }

}

# TODO: IS IGW ROUTE TABLE NECESSARY?
# SHOULD IT BE SOMETHING WITH LB?
resource "aws_route_table" "app_server_route_table" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = local.everything_cidr_block
    gateway_id = aws_internet_gateway.app_gw.id
  }
}

# TODO: SEE ABOVE
resource "aws_route_table_association" "app_server_route_table_association" {
  subnet_id      = aws_subnet.app_server_subnet.id
  route_table_id = aws_route_table.app_server_route_table.id
}

resource "aws_security_group" "app_server_security_group" {
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    description = ""
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = aws_subnet.load_balancer_subnet.*.cidr_block
  }

  ingress {
    description = ""
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.everything_cidr_block]
  }

  lifecycle {
    create_before_destroy = true
  }

}

