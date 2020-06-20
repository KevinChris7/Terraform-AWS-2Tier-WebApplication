### SNS Topic ###
resource "aws_sns_topic" "cjk-notifier" {
  name         = "cjk-notifier-topic"
  display_name = "Notification from CJK Project"
  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.alarms_email}"
  }
}

### Cloudwatch Metric Alarm - CPU ###
resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name          = "web-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = [aws_sns_topic.cjk-notifier.arn]
  dimensions = {
    //InstanceId = aws_instance.cjkapp.id
    InstanceId = var.cjkapp
  }
}

### Cloudwatch Metric Alarm - Health ###
resource "aws_cloudwatch_metric_alarm" "health" {
  alarm_name          = "web-health-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "1"
  alarm_description   = "This metric monitors ec2 health status"
  alarm_actions       = [aws_sns_topic.cjk-notifier.arn]

  dimensions = {
    //InstanceId = aws_instance.cjkapp.id
    InstanceId = var.cjkapp
  }
}

