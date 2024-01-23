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
              sudo amazon-linux-extras install java-openjdk11 -y
              sudo amazon-linux-extras install epel -y
              sudo yum install -y wget
              sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat/jenkins.repo
              sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
              sudo yum install -y jenkins
              sudo systemctl start jenkins
              EOF

  tags = {
    Name = "jenkins-instance"
  }
}

output "jenkins_url" {
  value = "http://${aws_instance.jenkins_instance.public_ip}:8080"
}
