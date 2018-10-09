provider "aws" {}

data "terraform_remote_state" "secrets" {
  backend = "atlas"
  config {
    name = "erik-rygg/secrets-aws-dev-us-west-2-quick"
  }
}

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

#TODO: create template for user_data

# For ease of use, put these instances in the bastion security group and allow them to have public access
resource "aws_instance" "otp_client" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  key_name               = "${data.terraform_remote_state.secrets.ssh_key_name}"
  #user_data             = "${}"
  subnet_id              = "${data.terraform_remote_state.secrets.subnet_public_ids.0}"
  vpc_security_group_ids = [
    "${data.terraform_remote_state.secrets.bastion_security_group}"
  ]
}

resource "aws_instance" "ca_client" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  key_name               = "${data.terraform_remote_state.secrets.ssh_key_name}"
  #user_data             = "${}"
  subnet_id              = "${data.terraform_remote_state.secrets.subnet_public_ids.0}"
  vpc_security_group_ids = [
    "${data.terraform_remote_state.secrets.bastion_security_group}"
  ]
}

