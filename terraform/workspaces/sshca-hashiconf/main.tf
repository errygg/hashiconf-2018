module "ssh_client_ca" {
  source          = "../modules/terraform-aws-ssh-client-ca"
  consul_version  = "${var.consul_version}"
  consul_url      = "${var.consul_url}"
  trusted_user_ca = "${var.trusted_user_ca}"
}