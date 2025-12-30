Naveen Gara, \[30-12-2025 04:29 PM]

You created a new Terraform project to deploy an EC2 instance in AWS. Which command must be run first to download the AWS provider?



A. terraform apply

B. terraform init ✅

C. terraform plan

D. terraform validate



Naveen Gara, \[30-12-2025 04:30 PM]

You want Terraform to deploy resources in the ap-south-1 AWS region. Where should this be defined?



A. Inside variables.tf

B. Inside terraform.tfstate

C. Inside the provider block ✅

D. Inside outputs.tf



Naveen Gara, \[30-12-2025 04:30 PM]

Before creating AWS resources, you want to see what changes Terraform will make without actually creating them.



A. terraform apply

B. terraform destroy

C. terraform plan ✅

D. terraform init



Naveen Gara, \[30-12-2025 04:31 PM]

You want to reuse the same EC2 configuration for different instance types like t2.micro and t3.micro. What should you use?



A. Hardcode values

B. Output blocks

C. Variables ✅

D. Providers



Naveen Gara, \[30-12-2025 04:32 PM]

After creating an EC2 instance, you want to display its public IP on the terminal.



A. variable

B. provider

C. output ✅

D. module



Naveen Gara, \[30-12-2025 04:33 PM]

Terraform needs AWS credentials to create resources. Which is a valid way?



A. Hardcoding in .tf files

B. Using AWS CLI configured credentials ✅

C. Saving in terraform.tfstate

D. Writing inside outputs.tf



Naveen Gara, \[30-12-2025 04:34 PM]

Your teammate says the Terraform project is broken because .terraform is missing. What do you tell them?



A. Download it from GitHub

B. Restore from backup

C. Run terraform init ✅

D. Copy from another system



Naveen Gara, \[30-12-2025 04:37 PM]

What file extension is used by Terraform configuration files?



A. .yaml

B. .json

C. .tf ✅

D. .cfg



Naveen Gara, \[30-12-2025 04:38 PM]

What is Terraform mainly used for?



A. Application development

B. Infrastructure as Code ✅

C. Monitoring servers

D. Container orchestration



Naveen Gara, \[30-12-2025 04:39 PM]

Error: No configuration files found

!When does this error occur?

A. .tf files are empty

B. Terraform state file is missing

C. You run Terraform in a directory without .tf files

D. Provider version mismatch



Naveen Gara, \[30-12-2025 04:40 PM]

Error: Missing required argument .Why does this happen?

A. Terraform init was skipped

B. Required resource argument is not provided ✅

C. State file is locked

D. Output block is wrong



Naveen Gara, \[30-12-2025 04:41 PM]

Error: Failed to query available provider packages

Most common reason?



A. Wrong variable type

B. Internet access issue

C. Duplicate resource name

D. Wrong state backend



Naveen Gara, \[30-12-2025 04:42 PM]

Error: Duplicate resource "aws\_instance" configuration

Why does this occur?



A. Same resource type used twice

B. Same resource name used twice ✅

C. Provider block duplicated

D. State file missing



Naveen Gara, \[30-12-2025 04:44 PM]

Error: Unsupported Terraform Core version

Why does this happen?



A. Terraform binary too old or too new

B. Provider not installed ✅

C. Wrong region

D. Variable missing



Naveen Gara, \[30-12-2025 04:46 PM]

Error creating EC2 Instance: UnauthorizedOperation

Why does this happen?



A. Wrong instance type

B. Missing IAM permissions ✅

C. Wrong subnet

D. AMI not found



Naveen Gara, \[30-12-2025 04:48 PM]

Error creating EC2 Instance: VPC Id Not Specified

What is missing?



A. Security group

B. Subnet ID ✅

C. AMI ID   ✅

D. Key pair

