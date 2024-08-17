variable "ami" {
  type = string
}

variable "instance_type" {

    type = list(string)
  
}

variable "security_group_id" {

    type= string
  
}

variable "keyfile" {

   type = string
}


variable "script" {

    type = list(string)

    default =  [  "sudo amazon-linux-extras install -y nginx1",
"sudo systemctl start nginx" ]
  
}
