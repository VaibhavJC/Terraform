resource "aws_security_group" "bastion-sg" {
  name = var.sg-name
  description = var.sg-description
  vpc_id = var.vpc-id
  ingress {
    from_port = var.sg-from-port-ing
    to_port = var.sg-to-port-ing
    protocol = var.sg-protocol-ing
    cidr_blocks = [ var.sg-cidr-blocks-ing ]
  }

  egress {
    from_port = var.sg-form-port-egr
    to_port = var.sg-to-port-egr
    protocol = var.sg-protocol-egr
    cidr_blocks = [var.sg-cidr_blocks-egr]
  }
}