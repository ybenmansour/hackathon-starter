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

data "aws_security_group" "jenkins_server_group" {
  id ="sg-000312648cb099634"
}

resource "aws_instance" "jenkins_server" {
  ami           = "ami-0fe5fc14a9ac91050"
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.jenkins_server_group.id]


}
