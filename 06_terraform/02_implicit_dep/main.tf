terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "2.69.0"
    }
  }
}

provider "aws" {
    region  = "eu-central-1"
    profile = "terraform-hw"
}

data "aws_ami" "amazon_linux" {
    most_recent = true
    owners      = ["amazon"]
    filter {
        name   = "name"
        values = ["amzn-ami-hvm-*-x86_64-gp2"]
    }
}

resource "aws_instance" "example_a" {
    ami           = data.aws_ami.amazon_linux.id
    instance_type = "t2.micro"
}
resource "aws_instance" "example_b" {
    ami           = data.aws_ami.amazon_linux.id
    instance_type = "t2.micro"
}
resource "aws_eip" "ip" {
    vpc      = true
    instance = aws_instance.example_a.id
}
