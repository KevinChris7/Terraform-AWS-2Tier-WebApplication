########### Data Source - Infrastructure ###########

### VPC Data ###
data "aws_vpc" "vpc_input" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "cjk"
  }
  depends_on = [aws_vpc.ivpc]
}

### Public Subnets ###
data "aws_subnet_ids" "subnet_ids_pub_input" {
  vpc_id     = data.aws_vpc.vpc_input.id
  tags = {
    Name = "IPublicSubnet*"
  }
}

### Private Subnet ###
data "aws_subnet" "subnet_id_priv_input" {
  vpc_id     = data.aws_vpc.vpc_input.id
  cidr_block = "10.0.3.0/24"
  tags = {
    Name = "IPrivateSubnet"
  }
}

### Application Security Group ###
data "aws_security_group" "secgp_cjkapp_input" {
  vpc_id = data.aws_vpc.vpc_input.id
  filter {
    name   = "group-name"
    values = ["cjkwebgrp"]
  }
}


########### Application Resources ###########

### Security Group of ELB ###
resource "aws_security_group" "sg_elb" {
  name   = "sg_elb"
  vpc_id = data.aws_vpc.vpc_input.id
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

### ELB ###
resource "aws_lb" "cjkalb" {
  name               = "cjkalb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_elb.id]
  subnets            = (data.aws_subnet_ids.subnet_ids_pub_input.ids)
}

### ELB Target Group ###
resource "aws_lb_target_group" "alb-tg" {
  name     = "cjkalb-tg"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc_input.id
}

### ELB Listener ###
resource "aws_lb_listener" "alb-list-http" {
  load_balancer_arn = aws_lb.cjkalb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}

### ELB Listener ###
# resource "aws_lb_listener" "alb-list-https" {
#   load_balancer_arn = aws_lb.cjkalb.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb-tg.arn
#   }
# }

### ELB Attachment ###
resource "aws_lb_target_group_attachment" "alb-ec2-attach" {
  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id        = aws_instance.webapp.id
  port             = 80
}

### EC2 Web Instance ###
resource "aws_instance" "webapp" {
  ami                    = lookup(var.AMIS, var.AWS_REGION)
  instance_type          = var.INSTANCE_TYP
  key_name               = var.KEYPAIR
  vpc_security_group_ids = [data.aws_security_group.secgp_cjkapp_input.id]
  subnet_id              = data.aws_subnet.subnet_id_priv_input.id
  tags = {
    Name = "CJKAPP"
  }
  user_data = file("apache.sh")
}