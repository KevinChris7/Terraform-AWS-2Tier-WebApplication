module "infrastructure" {
  source = "./modules/infrastructure"

  AWS_REGION          = var.AWS_REGION
  INSTANCE_TYP        = var.INSTANCE_TYP
  KEYPAIR             = var.KEYPAIR
  NATAMIS             = var.NATAMIS
  VPC_CIDR            = var.VPC_CIDR
  PUBLIC_SUBNET_CIDR  = var.PUBLIC_SUBNET_CIDR
  PUBLIC_SUBNET2_CIDR = var.PUBLIC_SUBNET2_CIDR
  PRIVATE_SUBNET_CIDR = var.PRIVATE_SUBNET_CIDR
}

module "application" {
  source = "./modules/application"

  AWS_REGION          = var.AWS_REGION
  AMIS                = var.AMIS
  INSTANCE_TYP        = var.INSTANCE_TYP
  KEYPAIR             = var.KEYPAIR
  VPC_CIDR            = var.VPC_CIDR
  PRIVATE_SUBNET_CIDR = var.PRIVATE_SUBNET_CIDR
  vpc                 = module.infrastructure.vpc
}

module "monitoring" {
  source = "./modules/monitoring"

  cjkapp       = module.application.ec2_app
  alarms_email = var.alarms_email
}