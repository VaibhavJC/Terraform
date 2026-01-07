resource "aws_instance" "ec2-1" {
  ami = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "Test"
  }
}

resource "aws_s3_bucket" "bucket_vc" {
  bucket = "tfstate-bucket-vc"
}

resource "aws_s3_bucket_versioning" "enable_versioning" {
  bucket = "tfstate-bucket-vc"

  versioning_configuration {
    status = "Enabled"
  }
}