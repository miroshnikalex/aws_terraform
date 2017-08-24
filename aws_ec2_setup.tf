provider "aws" {
  region     = "eu-central-1"
  profile    = "Alex"
}

resource "aws_security_group" "allow_ssh" {
  name		= "allow_ssh"
  description	= "Allow SSH access to the resources"
  tags {
       Name = "allow_ssh"
       }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "server-ansible" {
  ami           = "ami-657bd20a"
  instance_type = "t2.micro"
  key_name      = "Free-tier"
  availability_zone= "eu-central-1a"
  associate_public_ip_address = "true"
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
  tags {
       Name = "server-ansible"
       }
  provisioner "remote-exec" {
    inline = [
      "sudo yum-config-manager --enable epel",
      "sudo yum clean all",
      "sudo yum install ansible -y",
      "sudo yum update -y"
    ]
    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("~/terraform/.ssh/aws_ec2_Alex")}"
    }
  }
}

resource "aws_instance" "node-ansible-1" {
  ami           = "ami-657bd20a"
  instance_type = "t2.micro"
  key_name      = "Free-tier"
  availability_zone= "eu-central-1a"
  associate_public_ip_address = "true"
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
  tags {
       Name = "node-ansible-1"
       }
  provisioner "remote-exec" {
    inline = [
      "sudo yum-config-manager --enable epel",
      "sudo yum clean all",
      "sudo yum install ansible -y",
      "sudo yum update -y"
         ]
    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("~/terraform/.ssh/aws_ec2_Alex")}"
    }
  }
}

resource "aws_instance" "node-ansible-2" {
  ami           = "ami-657bd20a"
  instance_type = "t2.micro"
  key_name      = "Free-tier"
  availability_zone= "eu-central-1b"
  associate_public_ip_address = "true"
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
  tags {
       Name = "node-ansible-2"
       }
       provisioner "remote-exec" {
         inline = [
           "sudo yum-config-manager --enable epel",
           "sudo yum clean all",
           "sudo yum install ansible -y",
           "sudo yum update -y"
         ]
         connection {
           type = "ssh"
           user = "ec2-user"
           private_key = "${file("~/terraform/.ssh/aws_ec2_Alex")}"
         }
       }
}

resource "aws_instance" "node-ansible-3" {
  ami           = "ami-657bd20a"
  instance_type = "t2.micro"
  key_name      = "Free-tier"
  availability_zone= "eu-central-1c"
  associate_public_ip_address = "true"
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
  tags {
       Name = "node-ansible-3"
       }
  provisioner "remote-exec" {
    inline = [
      "sudo yum-config-manager --enable epel",
      "sudo yum clean all",
      "sudo yum install ansible -y",
      "sudo yum update -y"
         ]
    connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("~/terraform/.ssh/aws_ec2_Alex")}"
  }
 }
}
