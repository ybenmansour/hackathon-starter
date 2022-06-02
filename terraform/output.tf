output "ec2_jenkins_server" {
  value = aws_instance.jenkins_server.public_ip
}
