resource "aws_iam_policy" "custom_s3_policy" {
  name        = "custom-s3-read-write"
  description = "Allow read and write access to a S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::my-demo-bucket/*"
      }
    ]
  })
}

resource "aws_iam_role" "cust-role" {
    name = "custom-role"
  assume_role_policy = jsonencode(
    {
    Version = "2012-10-17",
    Statement = [
        {
            Effect = "Allow",
            Action = [
                "sts:AssumeRole"
            ],
            Principal = {
                Service = [
                    "lambda.amazonaws.com"
                ]
            }
        }
    ]
})
}

resource "aws_iam_policy_attachment" "name" {
    name = "policy-attachment"
    policy_arn = aws_iam_policy.custom_s3_policy.arn
    roles = [aws_iam_role.cust-role.name]
}