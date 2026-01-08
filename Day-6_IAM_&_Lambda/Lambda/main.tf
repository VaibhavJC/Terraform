resource "aws_lambda_function" "my-lambda-function" {
  function_name = "runpycode"
  runtime = "python3.14"
  handler = "app.lambda_handler"
  role = aws_iam_role.cust-lambda-role.arn
  filename = "app.zip"
  timeout = 900
  memory_size = 128

  source_code_hash = base64sha256("app.zip")
  depends_on = [aws_iam_role.cust-lambda-role]
}

resource "aws_iam_role" "cust-lambda-role" {
    name = "lambda-admin"
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

depends_on = [ aws_iam_policy.adminAccess ]
}

resource "aws_iam_policy" "adminAccess" {
    name = "adminAccess"
  policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                "Effect": "Allow",
                "Action": "*",
                "Resource": "*"
            }
        ]
    })
}

resource "aws_iam_policy_attachment" "attachment" {
    name = "policy-attachment"
    roles = [aws_iam_role.cust-lambda-role.name]
    policy_arn = aws_iam_policy.adminAccess.arn

    depends_on = [ aws_iam_policy.adminAccess, aws_iam_role.cust-lambda-role ]
}