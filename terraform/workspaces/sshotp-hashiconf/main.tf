data "terraform_remote_state" "vault" {
  backend = "atlas"
  config {
    name = "${var.org}/${var.workspace}"
  }
}

module "ssh_client_otp" {
  source = "../../modules/terraform-aws-ssh-client-otp"
  
  subnet_id              = "${data.terraform_remote_state.vault.subnet_public_ids.0}"
  vault_addr             = "http://${data.terraform_remote_state.vault.vault_lb_dns}"
  vpc_security_group_ids = ["${data.terraform_remote_state.vault.bastion_security_group}"]
}
