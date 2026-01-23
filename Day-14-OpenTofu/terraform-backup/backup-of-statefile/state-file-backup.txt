resource "aws_s3_bucket" "my-bucket" {
  bucket = "migration-test-bucket-vc"
}

resource "aws_s3_bucket_versioning" "bucket-versioning" {
    bucket = aws_s3_bucket.my-bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}