########### Application Outputs ###########
output "elb_arn" {
  value       = aws_lb.cjkalb.arn
  description = "ARN of Application Load Balancer"
}

output "elb_dns" {
  value       = aws_lb.cjkalb.dns_name
  description = "ARN of Application Load Balancer"
}

output "ec2_app" {
  value = aws_instance.cjkapp.id
}
