provider "aws" {
    region = "us-east-2"
}

resource "aws_instance" "my-instance" {
    count = 2
    ami = "ami-0c2f3d2ee24929520"
    key_name = "ohio"
    instance_type = "t2.micro"
    vpc_security_group_ids = [ aws_security_group.my-sg.id ]
        depends_on = [ aws_security_group.my-sg ]
    tags = {
        Name = "Instance-${count.index + 1}"
    }
}

resource "aws_security_group" "my-sg" {
    name = "all-allow-sg"
    description = "ALlow TLS inbound traffic"
    vpc_id = "vpc-0bf146a55b2b621eb"

    ingress {
        description = "TLS from VPC"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_tls"
    }
}