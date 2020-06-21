########### Infrastructure Variables ###########

variable "AWS_REGION" {}

variable "INSTANCE_TYP" {}

variable "KEYPAIR" {}

variable "VPC_CIDR" {}

variable "PUBLIC_SUBNET_CIDR" {}

variable "PUBLIC_SUBNET2_CIDR" {}

variable "PRIVATE_SUBNET_CIDR" {}

variable "NATAMIS" {}

variable "VPCENDPOINTSERVICE" {
  default = "com.amazonaws.ap-south-1.s3"
}