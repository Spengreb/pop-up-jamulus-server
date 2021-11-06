provider "aws" {
  region  = "eu-central-1"
}

resource "aws_instance" "jamulus" {
  ami             = "${data.aws_ami.image.id}"
  instance_type   = "c5.large"
  key_name        = "jamulus"
  security_groups = [ aws_security_group.ssh.name, aws_security_group.jamulus.name ] # Add your own IP to this group

  provisioner "file" {
    source  = "scripts/server-start.sh"
    destination = "/tmp/server-start.sh"

    connection {
      type = "ssh"
      user = "ubuntu"
      host = self.public_ip
      private_key = file("${path.module}/jamulus.pem")
    }
  }

  provisioner "remote-exec" {
    inline = [ 
      "sleep 45",
      "chmod +x /tmp/server-start.sh",
      "/tmp/server-start.sh"
    ]
    connection {
      type = "ssh"
      user = "ubuntu"
      host = self.public_ip
      private_key = file("${path.module}/jamulus.pem")
    }
  }

  tags = {
    Name = "jamulus-server"
  }
}

data "aws_ami" "image" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["Jamulus-*"]
  }
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "ssh" {
  name        = "jamulus-ssh-access"
  description = "Allow SSH inbound traffic"
}

resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ssh.id
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = [ "${chomp(data.http.myip.body)}/32" ]
  security_group_id = aws_security_group.ssh.id
}


resource "aws_security_group" "jamulus" {
  name        = "jamulus-port-access"
  description = "Allow jamulus inbound traffic"
}

resource "aws_security_group_rule" "jamulus" {
  type              = "ingress"
  to_port           = 22124
  from_port         = 22124
  protocol          = "udp"
  cidr_blocks       = [ "0.0.0.0/0"]
  security_group_id = aws_security_group.jamulus.id
}


output "instance_ip" {
  value = "${aws_instance.jamulus.public_ip}"
}
