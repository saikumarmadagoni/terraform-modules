provider "aws" {
  region = "us-east-1"
}


data "aws_vpc" "default" {
  default = true
}


resource "aws_security_group" "sg-webserver" {
  vpc_id      = data.aws_vpc.default.id
  name        = "webserver"
  description = "Security Group for Web Servers"

  dynamic "ingress" {

    for_each = var.ports
    iterator = ports

    content {

      protocol    = "tcp"
      from_port   = ports.value
      to_port     = ports.value
      cidr_blocks = ["${data.aws_vpc.default.cidr_block}","0.0.0.0/0"]

    }

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


output "security_group_id" {
    value = aws_security_group.sg-webserver.id
  
}