provider "aws" {
  region     = "${var.AWS_REGION}"
  profile    = "${var.AWS_PROFILE_NAME}"
}

resource "aws_instance" "server-ansible" {
  ami           = "${lookup(var.AWS_AMI, var.AWS_REGION)}"
  instance_type = "${var.AWS_INSTANCE_TYPE}"
  key_name      = "${var.AWS_KEY_NAME}"
  associate_public_ip_address = "true"
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
  tags {
       Name = "server-ansible"
       }
provisioner "remote-exec" {
  inline = [
    "sudo rpm -Uhv https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm",
    "sudo yum clean all",
    "sudo yum install ansible -y",
    "sudo yum update -y",
    "sudo useradd ${var.ANSIBLE_USER} -p ${var.ANSIBLE_PASSWORD}",
    "sudo sed -i 's/PermitRootLogin forced-commands-only/#PermitRootLogin forced-commands-only/g' /etc/ssh/sshd_config",
    "sudo sed -i 's/#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config",
    "sudo systemctl reload sshd"
        ]
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("~/terraform/.ssh/aws_ec2_Alex")}"
    }
  }
}
