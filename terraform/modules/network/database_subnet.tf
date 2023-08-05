data "aws_availability_zones" "available" {}

resource "aws_subnet" "db_subnet" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.0.${length(data.aws_availability_zones.available.names) + count.index}.0/24"
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "db_subnet-${element(data.aws_availability_zones.available.names, count.index)}"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.app_name}-private-subnet-group" # TODO: db-subnet-group
  subnet_ids = aws_subnet.db_subnet.*.id
}

resource "aws_security_group" "db_subnet_security_group" {
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    description = "Allow inbound traffic on port 5432 from public subnet"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public_subnet.cidr_block]
  }

  # TODO: can this be locked down more?
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

}
