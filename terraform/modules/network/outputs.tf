output "vpc_id" {
  value = aws_vpc.app_vpc.id
}

#output "app_server_subnet_id" {
#  value = aws_subnet.app_server_subnet.id
#}
#
#output "app_server_security_group_id" {
#  value = aws_security_group.app_server_security_group.id
#}
#
#output "app_server_cidr_block" {
#  value = local.app_server_cidr_block
#}

output "app_subnet_ids" {
  value = aws_subnet.app_subnet.*.id
}

output "db_subnet_group" {
  value = aws_db_subnet_group.db_subnet_group.id
}

output "db_security_group" {
  value = aws_security_group.db_subnet_security_group.id
}

output "ecs_security_group_id" {
  value = aws_security_group.ecs_security_group.id
}

output "vpc_link_security_group_id" {
  value = aws_security_group.vpc_link_security_group.id
}

output "cloudmap_service_arn" {
  value = aws_service_discovery_service.cloudmap_service.arn
}
