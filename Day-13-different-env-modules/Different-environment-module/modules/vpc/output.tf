output "pub-subnet-id" {
  value = aws_subnet.bastion-subnet.id
}

output "vpc_id" {
  value = aws_vpc.my-vpc.id
}