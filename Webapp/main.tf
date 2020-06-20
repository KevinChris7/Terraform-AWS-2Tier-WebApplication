module "infrastructure" {
  source = "./modules/infrastructure"

  AWS_REGION   = var.AWS_REGION
  INSTANCE_TYP = var.INSTANCE_TYP
  KEYPAIR      = var.KEYPAIR
  NATAMIS      = var.NATAMIS
}

module "application" {
  source = "./modules/application"

  AWS_REGION   = var.AWS_REGION
  AMIS         = var.AMIS
  INSTANCE_TYP = var.INSTANCE_TYP
  KEYPAIR      = var.KEYPAIR
  vpc          = module.infrastructure.vpc
}

module "monitoring" {
  source = "./modules/monitoring"

  cjkapp = module.application.ec2_app
  alarms_email = var.alarms_email
}