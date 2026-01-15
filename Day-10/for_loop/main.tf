resource "aws_security_group" "name" {
  name = "cust-SG-rules"
  description = "my custom set of SG"
  vpc_id = "vpc-01362098dcba72f6e"

  tags = {
    Name = "Cust-SG"
  }

  ingress = [
    for port in [22, 443, 3030, 80, 8080, 3000, 5000, 9000, 9300]:{
        description = "inboubd rules"
        from_port = port
        to_port = port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = false
  }]

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

