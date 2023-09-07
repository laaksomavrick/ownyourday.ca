resource "aws_sns_topic" "error_event" {
  name = "${var.app_name}-error-event-in-logs-topic"
}

resource "aws_sns_topic_subscription" "error_event_to_email" {
  topic_arn = aws_sns_topic.error_event.arn
  protocol  = "email"
  endpoint  = var.error_event_email
}

resource "aws_cloudwatch_log_metric_filter" "error_event_in_logs_metric_filter" {
  name           = "${var.app_name}-error-event-in-logs-metric-filter"
  log_group_name = var.log_group_name
  pattern        = "{$.status = 5*}"

  metric_transformation {
    name      = "${var.app_name}-error-event-in-logs-metric-filter"
    namespace = var.app_name
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "error_event_in_logs_alarm" {
  alarm_name          = "${var.app_name}-error-event-in-logs-alarm"
  metric_name         = aws_cloudwatch_log_metric_filter.error_event_in_logs_metric_filter.name
  threshold           = "0"
  statistic           = "Sum"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = "1"
  evaluation_periods  = "1"
  period              = "60"
  namespace           = var.app_name
  alarm_actions       = [aws_sns_topic.error_event.arn]
}
