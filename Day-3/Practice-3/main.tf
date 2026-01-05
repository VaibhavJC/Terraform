resource "aws_instance" "name" {

  ami = var.ami_id
  instance_type = var.t2-micro

    tags = {
      Name = "Dev"
    }
}

