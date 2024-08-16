

resource "aws_eip" "lb" {

  domain   = "vpc"
  count    = 2
  instance = var.instance-id[count.index].id
}