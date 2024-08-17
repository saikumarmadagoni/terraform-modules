provider "aws" {

    region = "us-east-1"
  
}




resource "aws_instance" "web-app" {

  ami           = var.ami

  for_each = var.instance_type

  

  instance_type = each.value
 
  tags = {
    
    createdAt = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())

  }


    connection {
        type = "ssh"
        user = "ec2-user"
        private_key = file("./${var.keyfile}.pem")
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
