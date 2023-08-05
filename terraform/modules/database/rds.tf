# https://www.hiveit.co.uk/techshop/terraform-aws-vpc-example/03-create-an-rds-db-instance

resource "aws_db_instance" "database" {
  allocated_storage = 10
  db_name           = "${var.app_name}-${var.environment}"
  engine            = "postgres"
  engine_version    = "11"
  instance_class    = "db.t3.micro"

  username = var.username
  password = var.password


  db_subnet_group_name   = var.db_subnet_group
  vpc_security_group_ids = [var.db_security_group]
  parameter_group_name   = aws_db_parameter_group.parameter_group.name

  # TODO; remove
  skip_final_snapshot = true
}

resource "aws_db_parameter_group" "parameter_group" {
  name   = "${var.app_name}-db-parameter-group"
  family = "postgres11"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  lifecycle {
    create_before_destroy = true
  }
}
