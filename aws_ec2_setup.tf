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
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"
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
      "sudo yum update -y",
      "sudo useradd ${var.ansible_user} -p ${var.ansible_password}",
      "sudo sed -i 's/PermitRootLogin forced-commands-only/#PermitRootLogin forced-commands-only/g' /etc/ssh/sshd_config",
      "sudo sed -i 's/#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config",
      "sudo su -",
      "touch /etc/sudoers.d/${var.ansible_user}",
      "echo '${var.ansible_user} ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/${var.ansible_user}",
      "service sshd reload",
      "exit"
        ]
    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("~/terraform/.ssh/aws_ec2_Alex")}"
    }
  }
}
