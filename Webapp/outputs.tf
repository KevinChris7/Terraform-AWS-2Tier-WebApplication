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
output "privatesubnet" {
  value = aws_subnet.iprivatesub.id
}
output "secgroup" {
  value       = aws_security_group.cjkwebgrp.id
  description = "Security Group Id"
}
output "vpcendpt" {
  value       = aws_vpc_endpoint.s3.id
  description = "VPC Endpoint for accessing AWS Resources"
}

//application outputs
output "elb" {
  value       = aws_lb.cjkalb.arn
  description = "ARN of Application Load Balancer"
}

output "instance_ip" {
  value       = aws_instance.webapp.public_ip
  description = "Public IP of CJKAPP Instance"
}