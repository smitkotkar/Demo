provider "aws" {
    region = "us-east-2"
}

resource "aws_instance" "my-instance" {
    count = 5
    ami = "ami-0c2f3d2ee24929520"
    key_name = "ohio"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["sg-0bf1e4b2a2e7674af"]
    tags = {
        Name = "Instance_1"
    }
}
