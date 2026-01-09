resource "aws_instance" "dev-instance" {
  ami = var.ami_id
  instance_type = var.instance_type
}