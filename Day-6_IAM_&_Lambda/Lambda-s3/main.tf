resource "aws_s3_bucket" "my-bucket" {
    bucket = "store-app-file-vc"
}

resource "aws_s3_bucket_versioning" "enable-versioning" {
  bucket = "store-app-file-vc"
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "app-file" {
    bucket = aws_s3_bucket.my-bucket.id
    key = "app.zip"
    source = "app.zip"

    etag = filemd5("app.zip")

}


resource "aws_lambda_function" "my-lambda-function" {
  function_name = "runpycode"
  runtime = "python3.14"
  handler = "app.lambda_handler"
  role = aws_iam_role.cust-lambda-role.arn
  timeout = 900
  memory_size = 128

  s3_bucket = aws_s3_bucket.my-bucket.id
  s3_key = aws_s3_object.app-file.key

  source_code_hash = filemd5("app.zip")

  depends_on = [aws_iam_role.cust-lambda-role]
}

resource "aws_iam_role" "cust-lambda-role" {
    name = "lambda-limited"
    assume_role_policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
        {
            "Effect" = "Allow",
            "Action" = [
                "sts:AssumeRole"
            ],
            "Principal" = {
                "Service" = [
                    "lambda.amazonaws.com"
                ]
            }
        }
    ]
})

depends_on = [ aws_iam_policy.lambda-limited ]
}

resource "aws_iam_policy" "lambda-limited" {
    name = "adminAccess"
  policy = jsonencode({
	Version = "2012-10-17",
	Statement = [
		{
			Sid = "Statement1",
			Effect = "Allow",
			Action = [
				"s3:*",
				"cloudwatch:*",
				"ec2:*"
			],
			Resource = [
				"*",
				"*",
				"*"
			]
		}
	]
})
}

resource "aws_iam_policy_attachment" "attachment" {
    name = "policy-attachment"
    roles = [aws_iam_role.cust-lambda-role.name]
    policy_arn = aws_iam_policy.lambda-limited.arn

    depends_on = [ aws_iam_policy.lambda-limited, aws_iam_role.cust-lambda-role ]
}