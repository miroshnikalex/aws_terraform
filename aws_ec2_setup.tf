provider "aws" {
  region     = "${var.AWS_REGION}"
  profile    = "${var.AWS_PROFILE_NAME}"
}

resource "aws_instance" "server-ansible" {
  count         = "${var.AWS_ANSIBLE_SERVER_COUNT}"
  availability_zone = "${element(var.AWS_AVZ[var.AWS_REGION], count.index)}"
  ami           = "${lookup(var.AWS_AMI, var.AWS_REGION)}"
  instance_type = "${var.AWS_INSTANCE_TYPE}"
  key_name      = "${var.AWS_KEY_NAME}"
  associate_public_ip_address = "true"
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
  tags {
       Name = "ansible-server${count.index}"
       }
provisioner "file" {
  source = "files/ansible-user-sudoers"
  destination = "/tmp/ansible-user-sudoers"
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file(".ssh/aws_ec2_Alex")}"
    }
}
provisioner "remote-exec" {
  inline = [
    "sudo rpm -Uhv https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm",
    "sudo yum clean all",
    "sudo yum install ansible vim mc -y",
    "sudo yum update -y",
    "sudo useradd -d /home/ansible-user -m -p $(echo '${var.ANSIBLE_PASSWORD_PLAIN}' | openssl passwd -1 -stdin) ansible-user",
    "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config",
    "sudo sed -i 's/#   StrictHostKeyChecking ask/StrictHostKeyChecking no/g' /etc/ssh/ssh_config",
    "sudo systemctl reload sshd",
    "sudo cp /tmp/ansible-user-sudoers /etc/sudoers.d",
    "sudo chown root:root /etc/sudoers.d/ansible-user-sudoers",
    "sudo chmod 440 /etc/sudoers.d/ansible-user-sudoers",
    "sudo rm -rf /tmp/ansible-user-sudoers",
    "sudo -u ansible-user mkdir /home/ansible-user/.ssh",
    "sudo -u ansible-user chmod 700 /home/ansible-user/.ssh",
    "sudo -u ansible-user ssh-keygen -t rsa -b 4096 -N '' -f /home/ansible-user/.ssh/ansible-key",
    "sudo -u ansible-user chmod 644 /home/ansible-user/.ssh/ansible-key.pub",
    "sudo -u ansible-user chmod 600 /home/ansible-user/.ssh/ansible-key",
    "sudo -u ansible-user sshpass -p ${var.ANSIBLE_PASSWORD_PLAIN} ssh-copy-id -i /home/ansible-user/.ssh/ansible-key.pub ${aws_instance.ansible-node1.private_ip}",
    "sudo -u ansible-user sshpass -p ${var.ANSIBLE_PASSWORD_PLAIN} ssh-copy-id -i /home/ansible-user/.ssh/ansible-key.pub ${aws_instance.ansible-node2.private_ip}",
    "sudo -u ansible-user sshpass -p ${var.ANSIBLE_PASSWORD_PLAIN} ssh-copy-id -i /home/ansible-user/.ssh/ansible-key.pub ${aws_instance.ansible-node3.private_ip}"
        ]
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file(".ssh/aws_ec2_Alex")}"
    }
  }
}

resource "aws_instance" "ansible-node" {
  count         = "${var.AWS_ANSIBLE_NODE_COUNT}"
  availability_zone = "${element(var.AWS_AVZ[var.AWS_REGION], count.index)}"
  ami           = "${lookup(var.AWS_AMI, var.AWS_REGION)}"
  instance_type = "${var.AWS_INSTANCE_TYPE}"
  key_name      = "${var.AWS_KEY_NAME}"
  associate_public_ip_address = "true"
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
  tags {
       Name = "ansible-node${count.index}"
       }
provisioner "file" {
  source = "files/ansible-user-sudoers"
  destination = "/tmp/ansible-user-sudoers"
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file(".ssh/aws_ec2_Alex")}"
    }
}
provisioner "remote-exec" {
  inline = [
    "sudo rpm -Uhv https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm",
    "sudo yum clean all",
    "sudo yum install ansible vim mc -y",
    "sudo yum update -y",
    "sudo useradd -d /home/ansible-user -m -p $(echo '${var.ANSIBLE_PASSWORD_PLAIN}' | openssl passwd -1 -stdin) ansible-user",
    "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config",
    "sudo sed -i 's/#   StrictHostKeyChecking ask/StrictHostKeyChecking no/g' /etc/ssh/ssh_config",
    "sudo systemctl reload sshd",
    "sudo cp /tmp/ansible-user-sudoers /etc/sudoers.d",
    "sudo chown root:root /etc/sudoers.d/ansible-user-sudoers",
    "sudo chmod 440 /etc/sudoers.d/ansible-user-sudoers",
    "sudo rm -rf /tmp/ansible-user-sudoers",
    "sudo -u ansible-user mkdir /home/ansible-user/.ssh",
    "sudo -u ansible-user chmod 700 /home/ansible-user/.ssh",
    "sudo -u ansible-user ssh-keygen -t rsa -b 4096 -N '' -f /home/ansible-user/.ssh/ansible-key",
    "sudo -u ansible-user chmod 644 /home/ansible-user/.ssh/ansible-key.pub",
    "sudo -u ansible-user chmod 600 /home/ansible-user/.ssh/ansible-key"
        ]
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file(".ssh/aws_ec2_Alex")}"
    }
  }
}
