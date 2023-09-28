output "log_group_name" {
  value = aws_cloudwatch_log_group.instance.name
}

output "cluster_name" {
  value = aws_ecs_cluster.app_cluster.name
}
