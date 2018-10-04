provider "aws" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ssh-otp-client" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  user_data = "./scripts/user_data.sh"
}

resource "aws_instance" "ssh-ca-client" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
}

