resource "aws_subnet" "app_server_subnet" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = local.app_server_cidr_block

  tags = {
    Name = "${var.app_name}-app_server_subnet-1"
  }

}

resource "aws_security_group" "app_server_security_group" {
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    description = ""
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [local.load_balancer_cidr_block]
  }

  ingress {
    description = ""
    from_port   = 22
    to_port     = 22
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

