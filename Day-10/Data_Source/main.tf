# data "aws_instance" "name" {
#     tags = {
#       Name = "Bastion"
#     }

#     filter {
#         name = "Bastion"
#         values = ["sg-0b8f1976b94742f1c"]
#     }

# }

data "aws_subnet" "name" {
  tags = {
    Name = "Pub-Subnet-A"
  }

  id = "subnet-073ff529f73f62013"
  
}


resource "aws_instance" "name" {
  ami = "ami-00ca570c1b6d79f36"
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.name.id
  tags = {
    Name = "Testing"
  }
}

# a read-only component used to fetch information from existing infrastructure, 
# external APIs, or other Terraform configurations for use in your current configuration
# We can call existing resources(already created) from cloud
