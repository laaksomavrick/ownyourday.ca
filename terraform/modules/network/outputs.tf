output "vpc_id" {
  value = aws_vpc.app_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "public_subnet_security_group_id" {
  value = aws_security_group.public_subnet_security_group.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "private_subnet_security_group_id" {
  value = aws_security_group.private_subnet_security_group.id
}
