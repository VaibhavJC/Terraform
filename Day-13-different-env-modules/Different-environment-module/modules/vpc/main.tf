resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    name = var.vpc_name
  }
}

resource "aws_subnet" "bastion-subnet" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = var.pub-subnet-cidr
  map_public_ip_on_launch = true
  availability_zone = var.pub-subnet-az
  tags = {
    Name = var.pub-subnet-tag
  }
}