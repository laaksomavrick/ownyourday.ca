# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Statistics-definitions.html
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/search-expression-syntax.html
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/CloudWatch-Dashboard-Body-Structure.html#CloudWatch-Dashboard-Properties-Metric-Widget-Object

locals {
  five_minutes = 300
  one_day      = 86400
  seven_days   = 604800
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.app_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 6
        height = 6

        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", "ownyourday-cluster", { stat : "Minimum", region : data.aws_region.current.name }],
            ["AWS/ECS", "CPUUtilization", "ClusterName", "ownyourday-cluster", { stat : "Maximum", region : data.aws_region.current.name }],
            ["AWS/ECS", "CPUUtilization", "ClusterName", "ownyourday-cluster", { stat : "Average", region : data.aws_region.current.name }]
          ]
          period  = local.five_minutes
          stacked = false
          region  = data.aws_region.current.name
          title   = "CPU utilization"
          view    = "timeSeries"
          yAxis = {
            left = {
              showUnits = true
            }
          }
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 6
        height = 6

        properties = {
          metrics = [
            ["AWS/ECS", "MemoryUtilization", "ClusterName", "ownyourday-cluster", { stat : "Minimum", region : data.aws_region.current.name }],
            ["AWS/ECS", "MemoryUtilization", "ClusterName", "ownyourday-cluster", { stat : "Maximum", region : data.aws_region.current.name }],
            ["AWS/ECS", "MemoryUtilization", "ClusterName", "ownyourday-cluster", { stat : "Average", region : data.aws_region.current.name }]
          ]
          period  = local.five_minutes
          stacked = false
          region  = data.aws_region.current.name
          title   = "Memory utilization"
          view    = "timeSeries"
          yAxis = {
            left = {
              showUnits = true
            }
          }
        }
      }
    ]
  })
}
