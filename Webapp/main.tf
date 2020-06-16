resource "aws_security_group" "sg_elb" {
  name   = "sg_elb"
  vpc_id = aws_vpc.ivpc.id
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
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
//load balancer
resource "aws_lb" "cjkalb" {
  name               = "cjkalb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_elb.id]
  subnet_mapping {
    subnet_id = aws_subnet.ipublicsub.id
  }
}
resource "aws_lb_target_group" "alb-tg" {
  name     = "cjkalb-tg"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = aws_vpc.ivpc.id
}
resource "aws_lb_listener" "alb-list-http" {
  load_balancer_arn = aws_lb.cjkalb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type   = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }  
}
resource "aws_lb_listener" "alb-list-https" {
  load_balancer_arn = aws_lb.cjkalb.arn
  port              = "443"
  protocol          = "HTTPS"
  default_action {
    type   = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }  
}
resource "aws_lb_target_group_attachment" "alb-ec2-attach" {
  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id        = aws_instance.webapp.id
  port             = 80
}

resource "aws_instance" "webapp" {
  ami                    = lookup(var.AMIS, var.AWS_REGION)
  instance_type          = var.INSTANCE_TYP
  key_name               = var.KEYPAIR
  vpc_security_group_ids = [aws_security_group.cjkwebgrp.id]
  subnet_id              = aws_subnet.iprivatesub.id
  tags = {
    Name = "CJKAPP"
  }
  user_data = file("apache.sh")
}