resource "aws_vpc" "ivpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "cjk"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ivpc.id
}

resource "aws_subnet" "ipublicsub" {
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.ivpc.id
  tags = {
    Name = "IPublicSubnet"
  }
}

resource "aws_subnet" "iprivatesub" {
  cidr_block = "10.0.16.0/20"
  vpc_id     = aws_vpc.ivpc.id
  tags = {
    Name = "IPrivateSubnet"
  }
}

resource "aws_route_table" "RTablePub" {
  vpc_id = aws_vpc.ivpc.id
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    cidr_block = "0.0.0.0/16"
    gateway_id = aws_internet_gateway.igw.id
  }

}

resource "aws_route_table" "RTablePriv" {
  vpc_id = aws_vpc.ivpc.id
  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = aws_instance.NatInstance.id
  }
  route {
    cidr_block  = "10.0.0.0/16"
    instance_id = aws_instance.NatInstance.id ///check//////
  }

}

resource "aws_route_table_association" "RTAssocPub" {
  subnet_id      = aws_subnet.ipublicsub.id
  route_table_id = aws_route_table.RTablePub.id
}

resource "aws_route_table_association" "RTAssocPriv" {
  subnet_id      = aws_subnet.ipublicsub.id
  route_table_id = aws_route_table.RTablePriv.id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id          = aws_vpc.ivpc.id
  service_name    = var.VPCENDPOINTSERVICE
  route_table_ids = [aws_route_table.RTableA.id, aws_route_table.RTableB.id]
}

resource "aws_security_group" "cjkwebgrp" {
  name   = cjkwebgrp
  vpc_id = aws_vpc.ivpc.id
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }
}
resource "aws_security_group" "natsecgrp" {
  name   = natsecgrp
  vpc_id = aws_vpc.ivpc.id
  ingress {
    description = "Inbound HTTP from Servers in Private Subnet"
    from_port   = 80
    to_port     = 80
    cidr_blocks = [aws_vpc.ivpc.cidr_block]
    protocol    = "tcp"
  }
  ingress {
    description = "Inbound HTTPS from Servers in Private Subnet"
    from_port   = 443
    to_port     = 443
    cidr_blocks = [aws_vpc.ivpc.cidr_block]
    protocol    = "tcp"
  }
  ingress {
    description = "Inbound SSH from network over IGW"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0./0"]
    protocol    = "tcp"
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }
}
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

resource "aws_eip" "eip" {
  vpc      = true
  instance = aws_instance.NatInstance.id
}


