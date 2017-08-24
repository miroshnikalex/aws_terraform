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

resource "aws_instance" "Ansible-1" {
  ami           = "ami-657bd20a"
  instance_type = "t2.micro"
  key_name      = "Free-tier"
  availability_zone= "eu-central-1a"
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
}

resource "aws_instance" "Ansible-2" {
  ami           = "ami-657bd20a"
  instance_type = "t2.micro"
  key_name      = "Free-tier"
  availability_zone= "eu-central-1b"
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
}

resource "aws_instance" "Ansible-3" {
  ami           = "ami-657bd20a"
  instance_type = "t2.micro"
  key_name      = "Free-tier"
  availability_zone= "eu-central-1c"
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
}
