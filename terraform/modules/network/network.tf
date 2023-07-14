# TODO: this may have to be revised when attempting to create EC2 + DB; no way to test mistakes yet

locals {
  everything_cidr_block     = "0.0.0.0/0"
  vpc_cidr_block            = "10.0.0.0/16"
  public_subnet_cidr_block  = "10.0.10.0/24"
  private_subnet_cidr_block = "10.0.20.0/24"
}

resource "aws_vpc" "app_vpc" {
  cidr_block = local.vpc_cidr_block
}

resource "aws_internet_gateway" "app_gw" {
  vpc_id = aws_vpc.app_vpc.id
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = local.public_subnet_cidr_block
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = local.private_subnet_cidr_block
  map_public_ip_on_launch = false
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = local.everything_cidr_block
    gateway_id = aws_internet_gateway.app_gw.id
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.app_vpc.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_network_acl" "public_subnet_nacl" {
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.app_vpc.cidr_block
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = aws_vpc.app_vpc.cidr_block
    from_port  = 443
    to_port    = 443
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.app_vpc.cidr_block
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = aws_vpc.app_vpc.cidr_block
    from_port  = 443
    to_port    = 443
  }

}

resource "aws_network_acl_association" "public_subnet_nacl_assoc" {
  network_acl_id = aws_network_acl.public_subnet_nacl.id
  subnet_id      = aws_subnet.public_subnet.id
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

resource "aws_security_group" "private_subnet_security_group" {
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    description = ""
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public_subnet.cidr_block]
  }

  ingress {
    description = ""
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public_subnet.cidr_block]
  }

  lifecycle {
    create_before_destroy = true
  }

}
