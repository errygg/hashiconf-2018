data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "userdata" {
  template = "${file("${path.module}/templates/userdata.sh.tpl")}"
  
  vars {
    namespace  = "${var.namespace}"
    vault_addr = "${var.vault_addr}"
  }
}

resource "aws_instance" "ca_client" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  key_name               = "${var.key_name}"
  subnet_id              = "${var.subnet_id}"
  user_data              = "${data.template_file.userdata.rendered}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
}

