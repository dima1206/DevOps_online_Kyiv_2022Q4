terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.27"      
    }
  }
}

provider "aws" {
    region  = "eu-central-1"
    profile = "terraform-hw"
}

resource "aws_instance" "example" {
    ami           = "ami-0a261c0e5f51090b1"
    instance_type = "t2.micro"
    tags          = {
        Name = var.instance_name
    }
}
