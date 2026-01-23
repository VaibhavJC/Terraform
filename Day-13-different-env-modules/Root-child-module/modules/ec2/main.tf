terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
  }
}

resource "aws_instance" "name" {
  ami = var.ami_id
  instance_type = var.my_instance

  tags = {
    Name = "vaibhav"
  }
}