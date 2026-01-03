resource "aws_instance" "ec2-1" {
  
  ami = "ami-00ca570c1b6d79f36"
  instance_type = "t2.medium"

    tags = {
      Name = "teprodst"
    }

    root_block_device {
      delete_on_termination = false
      tags = {
        Name = "EBS_Volume"
      }
    }
    
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "vaibhav-terraform-bucket-1302"
 
}

resource "aws_s3_bucket_versioning" "tf_bucket_version" {
    bucket = "vaibhav-terraform-bucket-1302"
  versioning_configuration {
    status = "Enabled"
  }
}