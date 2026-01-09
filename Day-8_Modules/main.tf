resource "aws_instance" "ec2" {
  ami = var.ami_id
  instance_type = var.instance

  tags = {
    Name = var.tag_name
  }
}

resource "aws_s3_bucket" "my-bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_object" "putobject" {
  bucket = var.bucket_name
  key = var.my_obj_key
  source = var.obj_src
}

resource "aws_s3_bucket_versioning" "enable_versionning" {
  bucket = var.bucket_name
  versioning_configuration {
    status = var.enbl_versioning
  }
}
