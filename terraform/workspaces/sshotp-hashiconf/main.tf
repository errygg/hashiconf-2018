data "terraform_remote_state" "vault" {
  backend = "atlas"
  config {
    name = "${var.org}/${var.workspace}"
  }
}

module "ssh_client_otp" {
  source = "../../modules/terraform-aws-ssh-client-otp"
  
  allowed_cidrs          = "${module.ssh_client_otp.otp_client_public_ip}"
  allowed_roles          = "web-developers"
  key_name               = "${data.terraform_remote_state.vault.ssh_key_name}"
  namespace              = "web-developers"
  subnet_id              = "${data.terraform_remote_state.vault.subnet_public_ids.0}"
  vault_addr             = "${data.terraform_remote_state.vault.vault_lb_dns}"
  vpc_security_group_ids = ["${data.terraform_remote_state.vault.bastion_security_group}"]

}
