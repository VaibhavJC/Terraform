resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

    tags = {
      Name = "my-vpc"
    }
}

resource "aws_subnet" "public_sub" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-Subnet"
  }
}

resource "aws_subnet" "private-sub" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Private-Subnet"
  }
}

resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-IG"
  }
}

resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
  }
}

resource "aws_route_table_association" "pub-subnet-association" {
  route_table_id = aws_route_table.pub-rt.id
  subnet_id = aws_subnet.public_sub.id
}

resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.main.id
  name = "SSH allow"
  description = "Allow TLS inbound traffic and all outbound traffic"

  tags = {
    Name = "SSH_allow"
  }

  ingress  {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress  {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "name" {
  
 ami = "ami-00ca570c1b6d79f36"
 instance_type = "t2.medium"

 subnet_id = aws_subnet.public_sub.id
 vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
   Name = "VAibhav_JC"
 }
}

resource "aws_eip" "eip_for_nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "my-nat" {
  allocation_id = aws_eip.eip_for_nat.id
  subnet_id = aws_subnet.public_sub.id

  tags = {
    Name = "NAT-GW"
  }
}

resource "aws_route_table" "pvt-rt" {
    vpc_id = aws_vpc.main.id

    route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.my-nat.id
    }
}

resource "aws_route_table_association" "pvt-rt-association" {
  route_table_id = aws_route_table.pvt-rt.id
  subnet_id = aws_subnet.private-sub.id
}