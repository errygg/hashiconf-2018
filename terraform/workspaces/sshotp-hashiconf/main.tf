module "ssh_client_otp" {
  source         = "../../modules/terraform-aws-ssh-client-otp"
  consul_version = "${var.consul_version}"
  consul_url     = "${var.consul_url}"
}
