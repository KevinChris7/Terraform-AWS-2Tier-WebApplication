########### Monitoring Outputs ###########
output "cjk_sns_topic_arn" {
  value       = aws_sns_topic.cjk-notifier.arn
  description = "ARN of SNS CJK Topic"
}