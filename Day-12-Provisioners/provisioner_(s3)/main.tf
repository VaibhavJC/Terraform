resource "aws_s3_bucket" "my_bucket" {
  bucket = "practice-provisioning-13-vc"
}

resource "aws_key_pair" "name" {
  key_name = "new_key2"
  public_key = file("~/.ssh/new_key2.pub")
}

resource "aws_iam_policy" "cust-policy" {
  name = "cust-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
            Effect = "Allow",
            Action =  "*",
            Resource = "*"
        }
    ]
  })
}

resource "aws_iam_role" "ec2-service" {
  name = "ec2_service1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "policy-attachment" {
  role = aws_iam_role.ec2-service.name
  policy_arn = aws_iam_policy.cust-policy.arn
  depends_on = [ aws_iam_policy.cust-policy, aws_iam_role.ec2-service ]
}

resource "aws_iam_instance_profile" "ec2-profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2-service.name
}

resource "aws_instance" "ec2" {
  ami = "ami-00ca570c1b6d79f36"
  instance_type = "t2.micro"
  key_name = aws_key_pair.name.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
  tags = {
    Name = "test"
  }
}

resource "null_resource" "upload-obj" {
  
  # provisioner "local-exec" {
  #   command = "aws s3 cp file.txt s3://${aws_s3_bucket.my_bucket.bucket}/file.txt"
  # }

  connection {
    type = "ssh"
    user = "ec2-user"
    host = aws_instance.ec2.public_ip
    private_key = file("~/.ssh/new_key2")
    timeout = "2m"
  }

  provisioner "file" {
    source = "file2.txt"
    destination = "/home/ec2-user/file2.txt"
  }

  provisioner "remote-exec" {
    inline = [
     "aws s3 cp file2.txt s3://${aws_s3_bucket.my_bucket.bucket}/file2.txt" ]
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}