output "ec2_jenkins_server" {
  description = "IP of the Jenkins Server instance"
  value = aws_instance.jenkins_server.public_ip
}

output "ec2_jenkins_instance" {
  description = "ID of the EC2 instance"
  value = aws_instance.jenkins_server.id
}
