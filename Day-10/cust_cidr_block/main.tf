# locals {
#   map_cidr = {
#     22 = "10.0.0.0/24"
#     443 = "10.0.1.0/24"
#     3030 = "10.0.2.0/24"
#     80 = "10.0.3.0/24"
#     8080 = "10.0.4.0/24"
#   }
# }

# resource "aws_security_group" "diff-cidr" {
#     vpc_id = "vpc-01362098dcba72f6e"
#     name = "diff-cidr"
#     description = "different cidr block with"

#     dynamic "ingress" {
#       for_each =  local.map_cidr
#       content {
#         description = "allow access to port ${ingress.key}"
#         from_port = ingress.key
#         to_port = ingress.key
#         protocol = "tcp"
#         cidr_blocks = ingress.value
#       }
#     }

#     egress {
#         from_port = 0
#         to_port = 0
#         protocol = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     tags = {
#       Name = "new_cidr"
#     }
# }

variable "my_port" {
  type = map(string)
  default = {
    22 = "10.0.0.0/24"
    443 = "10.0.1.0/24"
    80 = "10.0.2.0/24"
    8080 = "10.0.3.0/24"
    3000 = "10.0.4.0/24"
  }
}


resource "aws_security_group" "cust-sg" {
  name = "my-cust-sg"
  description = "Allow restricted inbound traffic"

  dynamic "ingress" {
    for_each = var.my_port
    content {
      description = "allow access to port ${ingress.key}"
      from_port = ingress.key
      to_port = ingress.key
      protocol = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}