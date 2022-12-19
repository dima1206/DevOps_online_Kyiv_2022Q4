provider "aws" {
    region  = "eu-central-1"
    profile = "terraform-hw"
}


resource "aws_instance" "Ubuntu20" {
    ami           = "ami-03dbc7bf3bdd5c676"
    instance_type = "t2.micro"

    tags = {
        Name    = "Ubuntu Server"
        Owner   = "DevOps Student"
        Project = "Terraform Intro"
    }
}

resource "aws_instance" "AmazonLinux" {
    ami           = "ami-0a261c0e5f51090b1"
    instance_type = "t2.micro"

    tags = {
        Name    = "Amazon Linux Server"
        Owner   = "DevOps Student"
        Project = "Terraform Intro"
    }
}
