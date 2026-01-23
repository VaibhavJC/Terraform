resource "aws_s3_bucket" "name" {
  bucket = var.my_bucket
}

resource "aws_s3_bucket_versioning" "bucket-versioning" {
  bucket = var.my_bucket

  versioning_configuration {
    status = var.versioning-enable
  }
}