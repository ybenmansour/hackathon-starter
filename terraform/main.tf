terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.74.0"
    }
  }
  required_version = ">= 1.1.4"
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
   most_recent = true

   filter {
     name   = "name"
     values = ["ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"]
   }

   filter {
     name   = "virtualization-type"
     values = ["hvm"]
   }

   filter {
     name   = "root-device-type"
     values = ["ebs"]
   }

  owners = ["099720109477"]
}

resource "aws_security_group" "jenkins_group" {
  name        = "allow_jenkins_conection"
  description = "Allowjenkins port inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "jenkins_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.jenkins_group.id]


}
