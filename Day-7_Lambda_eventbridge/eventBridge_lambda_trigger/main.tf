resource "aws_iam_role" "lambda-excution" {
    name = "lambda-basic-execution"
    assume_role_policy = jsonencode({
    Version = "2012-10-17",		 	 	 
    Statement = [
    {
      Effect =  "Allow",
      Principal = {
        "Service": "lambda.amazonaws.com"
      },
       Action = "sts:AssumeRole"
    }
  ]
})

    depends_on = [ aws_iam_policy.policy ]
}

resource "aws_iam_policy" "policy" {
    name = "cust-lambda-execution"
  policy = jsonencode({
	Statement = [
		{
			Action = [
				"logs:CreateLogGroup",
				"logs:CreateLogStream",
				"logs:PutLogEvents",
				"s3:*"
			],
			Effect = "Allow",
			Resource = [
				"*",
				"*"
			]
		},
		{
			Action = [
				"events:*"
			],
			Effect = "Allow",
			Resource = [
				"*"
			],
			"Sid": "Statement1"
		}
	],
	"Version": "2012-10-17"
})
}

resource "aws_iam_policy_attachment" "policy-attachment" {
    name = "policy-attachment"
    policy_arn = aws_iam_policy.policy.arn
    roles = [aws_iam_role.lambda-excution.name]

    depends_on = [ aws_iam_role.lambda-excution, aws_iam_policy.policy ]
}

resource "aws_lambda_function" "mypycode" {
    function_name = "mypycode"
    runtime = "python3.14"
    role = aws_iam_role.lambda-excution.arn
    filename = "app.zip"
    handler = "app.lambda_handler"
    timeout = 900
    memory_size = 128
    source_code_hash = base64sha256("app.zip")

    depends_on = [aws_iam_role.lambda-excution]
}

resource "aws_cloudwatch_event_rule" "eventRule" {
    name = "trigger-lambda"

    event_pattern = jsonencode({
    source = ["aws.s3"],
    detail-type = ["AWS API Call via CloudTrail"],
    detail = {
      "eventSource": ["s3.amazonaws.com"]
    }
  })

    
}

resource "aws_cloudwatch_event_target" "trigger_lambda" {
  rule = aws_cloudwatch_event_rule.eventRule.name
  arn = aws_lambda_function.mypycode.arn
  target_id = "lambda"

  depends_on = [ aws_cloudwatch_event_rule.eventRule, aws_lambda_function.mypycode ]
}

resource "aws_lambda_permission" "name" {
    statement_id = "AllowExecutionFromEventBridge"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.mypycode.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.eventRule.arn
}

resource "aws_s3_bucket" "mybucket" {
    bucket = "upload-object-to-trigger-lambda-vc"
}

resource "aws_s3_object" "putObjet" {
  bucket = "upload-object-to-trigger-lambda-vc"
  key = "The knight.png"
  source = "The knight.png"

  etag = filemd5("The knight.png")

  depends_on = [ aws_s3_bucket.mybucket ]
}