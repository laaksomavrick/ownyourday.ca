locals {
  five_minutes = 300
  one_hour     = 3600
  one_day      = 86400
  seven_days   = 604800
  width        = 6
  height       = 6
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.app_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = local.width
        height = local.height
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", var.cluster_name, { stat : "Minimum", region : data.aws_region.current.name }],
            ["AWS/ECS", "CPUUtilization", "ClusterName", var.cluster_name, { stat : "Maximum", region : data.aws_region.current.name }],
            ["AWS/ECS", "CPUUtilization", "ClusterName", var.cluster_name, { stat : "Average", region : data.aws_region.current.name }]
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
        width  = local.width
        height = local.height

        properties = {
          metrics = [
            ["AWS/ECS", "MemoryUtilization", "ClusterName", var.cluster_name, { stat : "Minimum", region : data.aws_region.current.name }],
            ["AWS/ECS", "MemoryUtilization", "ClusterName", var.cluster_name, { stat : "Maximum", region : data.aws_region.current.name }],
            ["AWS/ECS", "MemoryUtilization", "ClusterName", var.cluster_name, { stat : "Average", region : data.aws_region.current.name }]
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
        type   = "metric"
        x      = 12
        y      = 0
        width  = local.width
        height = local.height
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCountPerTarget", "TargetGroup", var.target_group_arn_suffix],
          ],
          stat    = "Sum"
          period  = local.five_minutes
          stacked = false
          region  = data.aws_region.current.name
          view    = "timeSeries"
          title   = "Request frequency"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = local.width
        height = local.height
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "HTTPCode_Target_2XX_Count", "TargetGroup", var.target_group_arn_suffix, "LoadBalancer", var.load_balancer_arn_suffix],
            [".", "HTTPCode_Target_4XX_Count", ".", ".", ".", "."],
            [".", "HTTPCode_Target_5XX_Count", ".", ".", ".", "."]
          ],
          stat    = "Sum"
          period  = local.seven_days
          stacked = false
          region  = data.aws_region.current.name
          view    = "singleValue"
          title   = "Response status codes"
        }
      },
      {
        type   = "metric"
        x      = 18
        y      = 0
        width  = local.width
        height = local.height
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "TargetGroup", var.target_group_arn_suffix, "LoadBalancer", var.load_balancer_arn_suffix, { stat : "p50" }],
            ["..."]
          ],
          stat    = "p99"
          period  = local.one_hour
          stacked = true
          region  = data.aws_region.current.name
          view    = "timeSeries"
          title   = "Request latency"
        }
      },
      {
        type   = "metric"
        x      = 18
        y      = 6
        width  = local.width
        height = local.height
        properties = {
          metrics = [
            [
              {
                expression : "m1 * 100", label : "Uptime %", id : "e1",
                period : 300
              }
            ],
            [
              "AWS/ApplicationELB", "HealthyHostCount", "TargetGroup",
              var.target_group_arn_suffix,
              "LoadBalancer",
              var.load_balancer_arn_suffix, {
                id : "m1", label : "HealthyHostCount", stat : "Average",
                visible : false
              }
            ]
          ],
          stat    = "SampleCount"
          period  = local.one_hour
          stacked = true
          region  = data.aws_region.current.name
          view    = "singleValue"
          title   = "Application uptime"
        },
      },
      {
        type   = "metric"
        x      = 6
        y      = 6
        width  = local.width
        height = local.height
        properties = {
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.db_identifier],
            ["...", { stat : "Minimum" }],
            ["...", { stat : "Maximum" }]
          ],
          stat    = "Average"
          period  = local.one_hour
          stacked = true
          region  = data.aws_region.current.name
          view    = "timeSeries"
          title   = "Database CPU utilization"
        }
      },
      {
        type   = "metric"
        x      = 6
        y      = 12
        width  = local.width
        height = local.height
        properties = {
          metrics = [
            ["AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", var.db_identifier]
          ],
          stat    = "Maximum"
          period  = local.one_hour
          stacked = true
          region  = data.aws_region.current.name
          view    = "singleValue"
          title   = "Database free disc space"
        }
      }
    ]
  })
}
