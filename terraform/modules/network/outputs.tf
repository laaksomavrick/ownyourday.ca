output "vpc_id" {
  value = aws_vpc.app_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "public_subnet_security_group_id" {
  value = aws_security_group.public_subnet_security_group.id
}

output "db_subnet_group" {
  value = aws_db_subnet_group.db_subnet_group.id
}

output "db_security_group" {
  value = aws_security_group.db_subnet_security_group.id
}
