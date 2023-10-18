output "vpc_id" {
  value = aws_vpc.app_vpc.id
}

output "app_server_subnet_id" {
  value = aws_subnet.app_server_subnet.id
}

output "app_server_security_group_id" {
  value = aws_security_group.app_server_security_group.id
}

output "db_subnet_group" {
  value = aws_db_subnet_group.db_subnet_group.id
}

output "db_security_group" {
  value = aws_security_group.db_subnet_security_group.id
}

output "reverse_proxy_security_group_id" {
  value = aws_security_group.reverse_proxy_security_group.id
}

output "reverse_proxy_subnet_id" {
  value = aws_subnet.reverse_proxy_subnet.id
}

output "cloudmap_service_arn" {
  value = aws_service_discovery_service.backend.arn
}
