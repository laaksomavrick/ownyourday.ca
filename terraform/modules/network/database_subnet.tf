resource "aws_subnet" "db_subnet" {
  count             = length(data.aws_availability_zones.vpc_link_enabled.names)
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.0.${length(data.aws_availability_zones.vpc_link_enabled.names) + count.index + local.db_subnet_cidr_tertiary_block}.0/24"
  availability_zone = element(data.aws_availability_zones.vpc_link_enabled.names, count.index)

  tags = {
    Name = "${var.app_name}-db_subnet-${element(data.aws_availability_zones.vpc_link_enabled.names, count.index)}"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.app_name}-db-subnet-group"
  subnet_ids = aws_subnet.db_subnet.*.id
}

# Only if you need to access via local
#resource "aws_route_table_association" "db_route_table_association-a" {
#  subnet_id      = aws_subnet.db_subnet.0.id
#  route_table_id = aws_route_table.app_route_table.id
#}
#
#resource "aws_route_table_association" "db_route_table_association-b" {
#  subnet_id      = aws_subnet.db_subnet.1.id
#  route_table_id = aws_route_table.app_route_table.id
#}

resource "aws_security_group" "db_subnet_security_group" {
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    description = "Allow inbound traffic on port 5432 from app server subnet"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [local.everything_cidr_block] # TODO: lock this down
  }

  lifecycle {
    create_before_destroy = true
  }

}
