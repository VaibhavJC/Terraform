
module "vpc" {
  source = "../../modules/vpc"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
  pub-subnet-cidr = var.pub-subnet-cidr
  pub-subnet-az = var.pub-subnet-az
  pub-subnet-tag = var.pub-subnet-tag
}

output "vpc-id" {
  value = module.vpc.vpc_id
}

module "bastion-sg" {
  source = "../../modules/sg"
  sg-name = var.sg-name
  sg-description = var.sg-description

  sg-from-port-ing = var.sg-from-port-ing
  sg-to-port-ing = var.sg-to-port-ing
  sg-protocol-ing = var.sg-protocol-ing
  sg-cidr-blocks-ing = var.sg-cidr-blocks-ing

  sg-form-port-egr = var.sg-form-port-egr
  sg-to-port-egr = var.sg-to-port-egr
  sg-protocol-egr = var.sg-protocol-egr
  sg-cidr_blocks-egr = var.sg-cidr_blocks-egr
  vpc-id = module.vpc.vpc_id
}

output "sg-id-exported" {
  value = module.bastion-sg.vpc_security_group_ids
}

output "pub-subnet-id" {
  value = module.vpc.pub-subnet-id
}

module "ec2_instance" {
  source = "../../modules/ec2"

  ami_id = var.ami_id
  my_instance  = var.my_instance
  sg-grp-id = module.bastion-sg.vpc_security_group_ids
  pub-subnet-id = module.vpc.pub-subnet-id
}


