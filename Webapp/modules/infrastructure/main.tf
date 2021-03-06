########### Infrastructure Resources ###########

### VPC ###
resource "aws_vpc" "ivpc" {
  cidr_block           = var.VPC_CIDR
  enable_dns_hostnames = true
  tags = {
    Name = "cjk"
  }
}

### Internet Gateway ###
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ivpc.id
}

### Public Subnet1 ###
resource "aws_subnet" "ipublicsub" {
  cidr_block              = var.PUBLIC_SUBNET_CIDR
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.ivpc.id
  availability_zone       = "${var.AWS_REGION}a"
  tags = {
    Name = "IPublicSubnet"
  }
}

### Public Subnet2 ###
resource "aws_subnet" "ipublicsub2" {
  cidr_block              = var.PUBLIC_SUBNET2_CIDR
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.ivpc.id
  availability_zone       = "${var.AWS_REGION}b"
  tags = {
    Name = "IPublicSubnet2"
  }
}

### Private Subnet ###
resource "aws_subnet" "iprivatesub" {
  cidr_block        = var.PRIVATE_SUBNET_CIDR
  vpc_id            = aws_vpc.ivpc.id
  availability_zone = "${var.AWS_REGION}b"
  tags = {
    Name = "IPrivateSubnet"
  }
}

### Route Table Public ###
resource "aws_route_table" "RTablePub" {
  vpc_id = aws_vpc.ivpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

### Route Table Private ###
resource "aws_route_table" "RTablePriv" {
  vpc_id = aws_vpc.ivpc.id
  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = aws_instance.NatInstance.id
  }
}

### Route Table Association Public 1 ###
resource "aws_route_table_association" "RTAssocPub" {
  subnet_id      = aws_subnet.ipublicsub.id
  route_table_id = aws_route_table.RTablePub.id
}

### Route Table Association Public 2 ###
resource "aws_route_table_association" "RTAssocPub2" {
  subnet_id      = aws_subnet.ipublicsub2.id
  route_table_id = aws_route_table.RTablePub.id
}

### Route Table Association Private ###
resource "aws_route_table_association" "RTAssocPriv" {
  subnet_id      = aws_subnet.iprivatesub.id
  route_table_id = aws_route_table.RTablePriv.id
}

### VPC Endpoint ###
resource "aws_vpc_endpoint" "s3" {
  vpc_id          = aws_vpc.ivpc.id
  service_name    = var.VPCENDPOINTSERVICE
  route_table_ids = [aws_route_table.RTablePub.id, aws_route_table.RTablePriv.id]
}

### Security Group - Application ###
resource "aws_security_group" "cjkdbgrp" {
  name       = "cjkdbgrp"
  depends_on = [aws_security_group.natsecgrp]
  vpc_id     = aws_vpc.ivpc.id
  ingress {
    description = "Inbound MYSQL Server acess from VPC"
    cidr_blocks = [aws_vpc.ivpc.cidr_block]
    //security_groups = [aws_security_group.natsecgrp.id]
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
  }
  ingress {
    description = "Inbound Microsoft SQL Server acess from VPC"
    cidr_blocks = [aws_vpc.ivpc.cidr_block]
    //security_groups = [aws_security_group.natsecgrp.id]
    from_port = 1433
    to_port   = 1433
    protocol  = "tcp"
  }
  # ingress {
  #   description     = "HTTPS from VPC"
  #   security_groups = [aws_security_group.natsecgrp.id]
  #   from_port       = 443
  #   to_port         = 443
  #   protocol        = "tcp"
  # }
  ingress {
    description = "SSH from VPC"
    cidr_blocks = [aws_vpc.ivpc.cidr_block, "0.0.0.0/0"]
    //security_groups = [aws_security_group.natsecgrp.id]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

### Security Group - NAT Instance ###
resource "aws_security_group" "natsecgrp" {
  name   = "natsecgrp"
  vpc_id = aws_vpc.ivpc.id
  ingress {
    description = "Inbound HTTP from Servers in Private Subnet"
    from_port   = 80
    to_port     = 80
    cidr_blocks = [aws_subnet.iprivatesub.cidr_block]
    protocol    = "tcp"
  }
  ingress {
    description = "Inbound HTTPS from Servers in Private Subnet"
    from_port   = 443
    to_port     = 443
    cidr_blocks = [aws_subnet.iprivatesub.cidr_block]
    protocol    = "tcp"
  }
  ingress {
    description = "Inbound SSH from network over IGW"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"] //need to give home network
    protocol    = "tcp"
  }
  ingress {
    description = "Ping Access"
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

### NAT Instance ###
resource "aws_instance" "NatInstance" {
  ami           = lookup(var.NATAMIS, var.AWS_REGION)
  instance_type = var.INSTANCE_TYP
  subnet_id     = aws_subnet.ipublicsub.id
  vpc_security_group_ids = [
    aws_security_group.natsecgrp.id
  ]
  source_dest_check = false
  key_name          = var.KEYPAIR
  tags = {
    Name = "NATInstance"
  }
}

### EIP ###
resource "aws_eip" "eip" {
  vpc      = true
  instance = aws_instance.NatInstance.id
}


