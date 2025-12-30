============Day - 1=============

================================



\*\*provider.tf



1\. provider.tf contains provider information to download plugins of specific providers, plugins will help to create infrastructure inside that specific provider

2\. provider block:



provider "aws"{



}



3\. when we hit "terraform init" request will goto provider.tf inside which provider we have given, that provider plugins will download from terraform registry.

4\. to create resources into specific AWS account first we need to configure the credentials of that account using "aws configure" command then configure access key and secret key

5\. we can mention which region we are using in provider block

6\. IF we want to use specific version of plugins we can explicitly mention providers plugins version:



terraform{

&nbsp;	required\_providers {

&nbsp;	aws = {

&nbsp;	source = "hashicorp/aws"

&nbsp;	version = "<5.0"

}

}

}





7\. now whenever we hit "terraform init" providers plugins will download for version < 5.0 and .terraform.lock.hcl file will create, inside this file 5.0 version lock will be enable.



8\. later if we want to upgrade plugins in provider.tf while initialize we need to use "terraform init --upgrade" command to use new version of provider plugins



============================================================================================================================================================================================



\*\*main.tf

&nbsp;

1\. main.tf contains, what resources we want to create that resources we need to mention into resource block of main.tf

2\. resource block:



resource "aws\_instance" "ec2" {

&nbsp;	ami\_id = "ami-12345678910"

&nbsp;	instance\_type = "t2.micro"

}



3\. "aws\_instance" --> resource which we want to create, "aws" --> name of resource block.

&nbsp;

\## Whenewer we hit "terraform init" .terraform folder and .terraform.lock.hcl file create



\## .terraform folder contains plugins of specific providers --> if we not mention any version inside provider block it will take recent updated version of provider plugins from terraform registry



\## .terraform.lock.hcl file contains downloaded plugins version, this file will enable lock for downloaded version, later if we hit terraform init multiple times it will not enable automatically upgrading version multiple times.



\######## upgrading version #############

Upgrading version is easy but, maintaining same code for upgraded version is not easy.

Let's say in present if we use 6.27.0 version of providers plugins in future maybe there maybe new version for the plugins

we can upgrade to new version but our present code is written using old version of plugins. Maybe new version of plugins require different code structure according to new version

in this case modifying complete code according to new version is not possible.

\######################################### 





\*\*\*\*\*\*\*\*\*\* alias tf = terraform \*\*\*\*\*\*\*\*

instead of writing terraform every time now we can use alias tf to run terraform command ex. tf init 



===========================================================================================================================================================================================



\*\*\*variable.tf



1\. we should not directly hardcode the values inside main.tf. Instead we can use variable.tf to create variables and store values inside the variables.



variable block:



variable "ami\_id" {

&nbsp;	

&nbsp;	descriptor = "passing values to main.tf"

&nbsp;	type = string            ## what type of data we are going to store in variables

&nbsp;	default = " " 



}



variable "type" {



&nbsp;	type = string

&nbsp;	default = ""



}





main.tf:



resource "aws\_instance" "aws"{

&nbsp;	ami\_id = var.ami\_id

&nbsp;	instance\_type = var.type

}





like this we can create variable blocks to store values in it and then we can call that variable block in main.tf.



============================================================================================================================================================================================



\*\*\*output.tf





1\. Here we can print the values directly after executing terraform code	

&nbsp;	we can print: a) instance availability zone	

&nbsp;		      b) instance public IP

&nbsp;		      c) instance private IP

&nbsp;		      d) instance subnet



to print outputs we need create output blocks"



output "print\_public\_ip" {

&nbsp;	value = aws\_instance.ec2.public\_ip

}



output "print\_private\_ip" {

&nbsp;	value = aws\_instance.ec2.private\_ip

}



output "print\_az" {

&nbsp;	value = aws\_instance.ec2.availability\_zone

}



2\. This output block also we can use as input for different source, we call specific block and use this as a source.





###### \# terraform apply -auto-approve ---- it will directly start creating resources without asking yes or no.



============================================================================================================================================================================================





\*\*\*terraform.tfvars



1\. We can pass the values from terraform.tfvars to variables to easily manage values.



2\. inside terraform.tfvars we can store values of variable



ex: ami\_id = "ami-12345678910"

&nbsp;   type = "t2.micro"



3\. from terraform.tfvars we can handle variables



terraform.tfvars --> variable.tf --> main.tf



