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
  template = "${file("${path.module}/userdata.sh.tpl")}"
  
  vars {
    cidrs      = "${var.allowed_cidrs ? var.allowed_cidrs : aws_instance.otp_client.public_ip}"
    namespace  = "${var.namespace}"
    roles      = "${var.allowed_roles}"
    vault_addr = "${var.vault_addr}"
  }
}

resource "aws_instance" "otp_client" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  key_name               = "${var.key_name}"
  subnet_id              = "${var.subnet_id}"
  user_data              = "${data.template_file.userdata.rendered}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
}
