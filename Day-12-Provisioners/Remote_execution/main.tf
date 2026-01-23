resource "aws_key_pair" "new_key" {
  key_name = "new_key"
  public_key = file("~/.ssh/new_key.pub")
}

resource "aws_instance" "name" {
  ami =  "ami-00ca570c1b6d79f36"
  instance_type = "t2.micro"
  key_name = aws_key_pair.new_key.key_name
  tags = {
    Name = "Dev"
  }

    connection {
        type = "ssh"
        user = "ec2-user"
        private_key = file("~/.ssh/new_key")  #path of private key
        host = self.public_ip
        timeout = "2m"
    }

    provisioner "remote-exec" {
      
      inline = [
        "touch /dev/temp/file1",
        "echo 'Hellow from lab1 >> /dev/temp/file1'"
        ]
    }

}

resource "null_resource" "new-file-create" {

  connection {
    type = "ssh"
    host = aws_instance.name.public_ip
    user = "ec2-user"
    private_key = file("~/.ssh/new_key")
  }

  provisioner "remote-exec" {
      
      inline = [
        "touch file1",
        "echo 'Hellow from null resource >> file1'",
        ]
    }

   provisioner "local-exec" {
      command = "echo 'hello from vishesh' >> file100.txt"
    # command = "touch file10"
    # command = "rm -rf file10"
    }

    triggers = {
      always_run = "${timestamp()}"
    }
}