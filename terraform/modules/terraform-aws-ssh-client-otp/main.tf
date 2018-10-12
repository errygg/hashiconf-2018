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

data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.sh.tpl")}"
  
  vars {
    consul_version  = "${vars.consul_version}"
    consul_url      = "${vars.consul_url}"
    trusted_user_ca = "${vars.trusted_user_ca}"
  }
}

# For ease of use, put this instance in the bastion security group and allow
# it to have public access
resource "aws_instance" "otp_client" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  key_name               = "${data.terraform_remote_state.secrets.ssh_key_name}"
  user_data              = "${data.template_file.user_data.rendered}"
  subnet_id              = "${data.terraform_remote_state.secrets.subnet_public_ids.0}"
  vpc_security_group_ids = [
    "${data.terraform_remote_state.secrets.bastion_security_group}"
  ]
}