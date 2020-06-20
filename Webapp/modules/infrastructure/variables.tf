########### Infrastructure Variables ###########

variable "AWS_REGION" {}

variable "INSTANCE_TYP" {}

variable "KEYPAIR" {}

variable "NATAMIS" {}

variable "VPCENDPOINTSERVICE" {
  default = "com.amazonaws.ap-south-1.s3"
}