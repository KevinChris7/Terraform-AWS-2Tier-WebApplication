########### Provider Variables ###########
variable "AWS_REGION" {
  default = "ap-south-1"
}

variable "INSTANCE_TYP" {
  default = "t2.micro"
}

variable "AMIS" {
  default = {
    ap-south-1 = "ami-0447a12f28fddb066"
    us-east-1  = "ami-01233435345454454"
  }
}

variable "KEYPAIR" {
  default = "my_ec2_keypair"
}

variable "NATAMIS" {
  default = {
    ap-south-1 = "ami-0aba92643213491b9"
  }
}

variable "alarms_email" {
  default = "kevinchristopherkc7@gmail.com"
}

variable "bucket_backend" {
  default = "terraform-state-7777"
}

variable "VPC_CIDR" {
  default = "10.0.0.0/16"
}

variable "PUBLIC_SUBNET_CIDR" {
  default = "10.0.1.0/24"
}

variable "PUBLIC_SUBNET2_CIDR" {
  default = "10.0.2.0/24"
}

variable "PRIVATE_SUBNET_CIDR" {
  default = "10.0.3.0/24"
}