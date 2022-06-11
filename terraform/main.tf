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
  id ="sg-090df9b3d5604bae1"
}

resource "aws_instance" "jenkins_server" {
  ami           = "ami-0bf36a83943035310"
  instance_type = "t2.medium"
  vpc_security_group_ids = [data.aws_security_group.jenkins_server_group.id]
  instance_initiated_shutdown_behavior = "terminate"


}
