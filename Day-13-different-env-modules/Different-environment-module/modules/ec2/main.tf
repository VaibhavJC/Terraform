resource "aws_instance" "ec-2" {
  ami = var.ami_id
  instance_type = var.my_instance
  vpc_security_group_ids = [var.sg-grp-id]
  subnet_id = var.pub-subnet-id
}
