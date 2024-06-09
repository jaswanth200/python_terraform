terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.46.0"  // Ensure this version works with your modules
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#creating vpc
resource "aws_vpc" "provpc" {
  cidr_block = "10.10.0.0/16"

  tags = {   
    Name = "provpc"
  }
}

#creating internet_gateway
resource "aws_internet_gateway" "proig" {
  vpc_id = aws_vpc.provpc.id

  tags = {
    Name = "proig"
  }
}

#creating subnet in avalibitlity zone us-east-1a
resource "aws_subnet" "aval_1a_subnet" {
  vpc_id     = aws_vpc.provpc.id
  cidr_block = "10.10.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "aval_1a_subnet"
  }
}

#creating route table for aval-1a
resource "aws_route_table" "aval_1a_rt" {
  vpc_id = aws_vpc.provpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.proig.id
  }

  tags = {
    Name = "aval_1a_rt"
  }
}

#attaching public route table to avalabitlity zone 1a subnet 
resource "aws_route_table_association" "public_attach_1a" {
  subnet_id      = aws_subnet.aval_1a_subnet.id
  route_table_id = aws_route_table.aval_1a_rt.id
}

#creating subnet avalibitlity zone us-east-1b
resource "aws_subnet" "aval_1b_subnet" {
  vpc_id     = aws_vpc.provpc.id
  cidr_block = "10.10.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "aval_1b_subnet"
  }  
}


#creating route table for aval-1b
resource "aws_route_table" "aval_1b_rt" {
  vpc_id = aws_vpc.provpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.proig.id
  }

  tags = {
    Name = "aval_1b_rt"
  }
}

#attaching public route table to avalabitlity zone 1b subnet 
resource "aws_route_table_association" "public_attach_1b" {
  subnet_id      = aws_subnet.aval_1b_subnet.id
  route_table_id = aws_route_table.aval_1b_rt.id
}


#creating subnet avalibitlity zone us-east-1c
resource "aws_subnet" "aval_1c_subnet" {
  vpc_id     = aws_vpc.provpc.id
  cidr_block = "10.10.3.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "aval_1c_subnet"
  }  
}


#creating route table for aval-1c
resource "aws_route_table" "aval_1c_rt" {
  vpc_id = aws_vpc.provpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.proig.id
  }

  tags = {
    Name = "aval_1c_rt"
  }
}

#attaching public route table to avalabitlity zone 1c subnet 
resource "aws_route_table_association" "public_attach_1c" {
  subnet_id      = aws_subnet.aval_1c_subnet.id
  route_table_id = aws_route_table.aval_1c_rt.id
}


#creating security_group for instance
resource "aws_security_group" "prosg" {
  name        = "prosg"
  vpc_id      = aws_vpc.provpc.id
  description = "security_group"

  ingress {
    description = "http from all internet"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http from all internet"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description      = "http to all internet"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"] 
  }
}

resource "aws_instance" "python_First_Instance" {
  ami           = "ami-0f58b397bc5c1f2e8"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.aval_1a_subnet.id
  security_groups = [aws_security_group.prosg.id]
  tags = {
    Name = "pythonFirstInstance"
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y python3
              sudo apt-get install -y python3-pip
              EOF
    key_name = "jenkinskey"
    associate_public_ip_address = true
}

resource "aws_ami_from_instance" "python_First_Instance_ami" {
  name               = "python_First_Instance-ami"
  source_instance_id = aws_instance.python_First_Instance.id
  depends_on         = [aws_instance.python_First_Instance]
  tags = {
    Name = "python_FirstInstanceAMI"
  }
}
