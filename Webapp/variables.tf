########### Provider Variables ###########
variable "AWS_REGION" {
  default = "ap-south-1"
}

########### Application Variables ###########
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

########### Infrastructure Variables ###########

variable "NATAMIS" {
  default = {
    ap-south-1 = "ami-0aba92643213491b9"
  }
}

variable "VPCENDPOINTSERVICE" {
  default = "com.amazonaws.ap-south-1.s3"
}
