module "dev" {
  source = "../.."

  ami_id = "ami-00ca570c1b6d79f36"
  instance ="t3.micro"

  tag_name = "Dev"

  bucket_name = "my-terraform-bucket-vc"

  my_obj_key = "The knight.png"

  obj_src = "The knight.png"

  enbl_versioning = "Enabled"

}
