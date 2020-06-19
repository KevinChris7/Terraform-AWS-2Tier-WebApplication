########### Infrastructure Outputs ###########
output "vpc" {
  value       = aws_vpc.ivpc.arn
  description = "ARN of VPC"
}

output "vpc_cidr" {
  value       = aws_vpc.ivpc.cidr_block
  description = "CIDR Block of VPC"
}

output "vpcid" {
  value       = aws_vpc.ivpc.id
  description = "ID of VPC"
}

output "publicsubnet" {
  value = aws_subnet.ipublicsub.id
}

output "publicsubnet2" {
  value = aws_subnet.ipublicsub2.id
}

output "privatesubnet" {
  value = aws_subnet.iprivatesub.id
}

output "secgroup" {
  value       = aws_security_group.cjkdbgrp.id
  description = "DB Security Group Id"
}

output "vpcendpt" {
  value       = aws_vpc_endpoint.s3.id
  description = "VPC Endpoint for accessing AWS Resources"
}

########### Application Outputs ###########
output "elb_arn" {
  value       = aws_lb.cjkalb.arn
  description = "ARN of Application Load Balancer"
}

output "elb_dns" {
  value       = aws_lb.cjkalb.dns_name
  description = "ARN of Application Load Balancer"
}

output "nat_instance_ip" {
  value       = aws_instance.NatInstance.public_ip
  description = "Public IP of NAT Instance"
}

########### Monitoring Outputs ###########
output "cjk_sns_topic_arn" {
  value       = aws_sns_topic.cjk-notifier.arn
  description = "ARN of SNS CJK Topic"
}