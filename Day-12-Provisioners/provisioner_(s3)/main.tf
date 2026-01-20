resource "aws_s3_bucket" "my_bucket" {
  bucket = "practice-provisioning-13-vc"
}

resource "null_resource" "upload-obj" {
  provisioner "local-exec" {
    command = "aws s3 cp file.txt s3://${aws_s3_bucket.my_bucket.bucket}/file.txt"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}