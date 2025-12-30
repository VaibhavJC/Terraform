resource "aws_instance" "ec2" {
  
  ami = var.ami_id
  instance_type = var.t2-micro

}

