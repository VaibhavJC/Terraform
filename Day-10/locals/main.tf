locals {
  instance_type = "t2.micro"
  ami_id = "ami-00ca570c1b6d79f36"
  my_region = "us-east-1"
}

resource "aws_instance" "ec2-1" {
  ami = local.instance_type
  instance_type = local.instance_type
  region = local.my_region
}


# locals (local values) assign a name to an expression or a value for reuse within a module