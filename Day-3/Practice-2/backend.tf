terraform {
  backend "s3" {
    bucket = "vaibhav-terraform-bucket-1302"
    key = "terraform.tfstate"
    region = "ap-south-1"
    
    use_lockfile = true
  }
}