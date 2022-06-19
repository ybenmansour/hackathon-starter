terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.74.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-3"
}

resource "aws_security_group" "sg_jenkins_server" {
  name        = "allow_jenkins_connection"
  description = "allow_jenkins_connection 8080"

  ingress {
    from_port   = 8080
    to_port     = 8080
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
  ami           = "ami-042e1b063a45d3a68"
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.sg_jenkins_server.id]
  #instance_initiated_shutdown_behavior = "terminate"
  tags = {
    Name = "Jenkins Instance"
  }
  
  root_block_device {
    volume_size    = 10
    volume_type    = "gp2"
  }


}
