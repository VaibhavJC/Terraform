resource "aws_instance" "ec2-testing" {
  ami = "ami-00ca570c1b6d79f36"
  instance_type = "t2.micro"

  tags = {
    Name = "Testing"
  }
}

# Taking control of existing resources using terraform. Manually or already created resources able to modify using terraform.
# terraform import aws_instance.ec2-testing i-0cb64b1eaaa6fa6b0