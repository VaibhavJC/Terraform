module "ec2_instance" {
    source = "./modules/ec2/"

    
    ami_id  = "ami-00ca570c1b6d79f36"
    my_instance = "t2.micro"

  
}

module "s3_bucket" {
  source = "./modules/s3"
  my_bucket = "my-new-bucket-vc-13"

  versioning-enable = "Enabled"
}