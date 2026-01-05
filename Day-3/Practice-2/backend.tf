terraform {
  backend "s3" {
    bucket = "vaibhav-terraform-bucket-1302"
    key = "terraform.tfstate"
    region = "ap-south-1"
    
    #lockfile will enable lock for the apply request, who hit first apply request
    #file locking using s3 bucket
    use_lockfile = true
  }
}