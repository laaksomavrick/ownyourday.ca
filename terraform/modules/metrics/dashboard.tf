# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Statistics-definitions.html
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/search-expression-syntax.html
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/CloudWatch-Dashboard-Body-Structure.html#CloudWatch-Dashboard-Properties-Metric-Widget-Object

# TODO:
# DB cpu, memory, disc

# request latencies
# 2xx, 4xx, 5xx rates
# GET, POST, ... counts
# Payload size (data transfer over time)?
# Uptime

# Number of Successful deployments
# Time to deploy

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
          title   = "Cluster CPU utilization"
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
          title   = "Cluster memory utilization"
          view    = "timeSeries"
          yAxis = {
            left = {
              showUnits = true
            }
          }
        }
      },
      {
        type = "metric"
        x = 6
        y = 0
        width = 6
        height = 6
        properties = {
          metrics = [
            [ "AWS/ApplicationELB", "RequestCountPerTarget", "TargetGroup", "targetgroup/ownyourday-lb-target-group/d980f1d5be1a8460", { visible : false } ],
            [ ".", "RequestCount", ".", ".", "LoadBalancer", "app/ownyourday-app-load-balancer/bae0e3e1c8bd45fb" ]
          ],
          stat = "Sum"
          period = local.five_minutes
          stacked = false
          region = data.aws_region.current.name
          view = "timeSeries"
          title   = "Request frequency"
        }
      }
    ]
  })
}
