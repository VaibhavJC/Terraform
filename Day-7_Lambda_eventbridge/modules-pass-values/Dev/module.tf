module "dev" {
  source = "../Module/dev"
  ami_id = "ami-00ca570c1b6d79f36"
  instance_type = "t2.micro"
}
