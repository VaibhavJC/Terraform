terraform {
  backend "s3" {
    bucket = "tfstate-bucket-vc"
    key = "day-4/tfstate"
    region = "ap-south-1"

    #DynamoDB state lockfile
     dynamodb_table = "tfstate-lockfile"
     encrypt = true
  }
}