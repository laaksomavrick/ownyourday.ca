output "vpc_id" {
  value = aws_vpc.app_vpc.id
}

output "app_server_subnet_id" {
  value = aws_subnet.app_server_subnet.id
}

output "app_server_security_group_id" {
  value = aws_security_group.app_server_security_group.id
}

output "app_server_cidr_block" {
  value = local.app_server_cidr_block
}

output "lb_subnet_ids" {
  value = aws_subnet.load_balancer_subnet.*.id
}

output "lb_subnet_id" {
  value = aws_subnet.load_balancer_subnet.0.id
}

output "lb_security_group_id" {
  value = aws_security_group.load_balancer_security_group.id
}

output "db_subnet_group" {
  value = aws_db_subnet_group.db_subnet_group.id
}

output "db_security_group" {
  value = aws_security_group.db_subnet_security_group.id
}

output "nginx_security_group_id" {
  value = aws_security_group.nginx_security_group.id

}
