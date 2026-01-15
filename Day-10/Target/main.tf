resource "aws_instance" "ec2-run" {
    ami = "ami-00ca570c1b6d79f36"
    instance_type = "t2.micro"

    tags = {
      Name = "Run"
    }
}

resource "aws_s3_bucket" "my-bucket" {
    bucket = "new-bucket-vc-1302"
}

resource "aws_s3_bucket_versioning" "enable-versioning" {
  bucket = aws_s3_bucket.my-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


# To create only targeted resources.
# If our terraform code contains many resource blocks and we want to create only needful resource in this case we can use target.

# terraform plan -target=aws_s3_bucket.name 
# terraform destroy -target=aws_s3_bucket.name
