resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = local.private_subnet_cidr_block
  map_public_ip_on_launch = false
}

resource "aws_network_acl" "private_subnet_nacl" {
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_subnet.public_subnet.cidr_block
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = aws_subnet.public_subnet.cidr_block
    from_port  = 443
    to_port    = 443
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_subnet.public_subnet.cidr_block
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = aws_subnet.public_subnet.cidr_block
    from_port  = 443
    to_port    = 443
  }

}

resource "aws_network_acl_association" "private_subnet_nacl_assoc" {
  network_acl_id = aws_network_acl.private_subnet_nacl.id
  subnet_id      = aws_subnet.private_subnet.id
}

resource "aws_security_group" "public_subnet_security_group" {
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    description = ""
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.app_vpc.cidr_block]
  }

  ingress {
    description = ""
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.app_vpc.cidr_block]
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.app_vpc.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}


