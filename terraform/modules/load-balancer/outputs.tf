output "target_group_arn" {
  value = aws_lb_target_group.app_lb_target_group.arn
}


output "alb_dns_name" {
  value = aws_lb.app_load_balancer.dns_name
}

output "alb_zone_id" {
  value = aws_lb.app_load_balancer.zone_id
}
