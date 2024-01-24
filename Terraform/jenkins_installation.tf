provider "aws" {
  region = "us-east-2"  # Replace with your desired AWS region
}

resource "aws_instance" "jenkins_instance" {
  ami           = "ami-0c2f3d2ee24929520"  # Replace with your desired Jenkins-ready AMI ID (e.g., an Ubuntu AMI with Jenkins pre-installed)
  instance_type = "t2.micro"                # Replace with your desired instance type
  key_name      = "ohio"          # Replace with your key pair name
  vpc_security_group_ids = [ "sg-0c85dc03183984b63" ]  # Replace with your security group ID(s)

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y wget
              sudo curl -O /etc/yum.repos.d/jenkins.repo   https://pkg.jenkins.io/redhat-stable/jenkins.repo
              sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
              sudo yum upgrade -y
              sudo yum install fontconfig java-11-openjdk
              sudo yum install jenkins -y
              sudo systemctl daemon-reload
              sudo systemctl enable jenkins
              sudo systemctl start jenkins
              EOF

  tags = {
    Name = "jenkins-instance"
  }
}

output "jenkins_url" {
  value = "http://${aws_instance.jenkins_instance.public_ip}:8080"
}