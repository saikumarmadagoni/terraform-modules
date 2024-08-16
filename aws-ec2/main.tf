provider "aws" {

    region = "us-east-1"
  
}


resource "tls_private_key" "private-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my-key-pair" {
  key_name   = "YourKey"
  public_key = tls_private_key.private-key.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.my-key-pair.key_name}.pem"
  content = tls_private_key.private-key.private_key_pem
}

resource "aws_instance" "web-app" {

  ami           = var.ami

  for_each = set(var.instance_type)

  

  instance_type = each.value
 
  tags = {
    
    createdAt = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())

  }


    connection {
        type = "ssh"
        user = "ec2-user"
        private_key = file("./${aws_key_pair.generated_key.key_name}.pem")
        host = self.public_ip
    }
  

    provisioner "remote-exec" {
        inline = var.script
    }

  vpc_security_group_ids = [var.security_group_id]

  lifecycle {
    ignore_changes = [instance_type]
  }

  

}

output "instance-ids" {

    value=aws_instance.web-app[*]
}
