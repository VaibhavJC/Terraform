# resource "aws_instance" "name" {
#     ami = "ami-00ca570c1b6d79f36"
#     instance_type = "t2.micro"
#     count = 2 # it will create 2 instances

#     tags = {
#       Name = "dev-${count.index}" # it will give tag name dev-0 and dev-1 
#     }
# }


variable "my-ec2-env" {
    type = list(string)
    default = ["test","prod"]
}

resource "aws_instance" "ec2" {
    ami = "ami-00ca570c1b6d79f36"
    instance_type = "t2.micro"
    count = length(var.my-ec2-env)
    tags = {
      Name = var.my-ec2-env[count.index]
    }
}

