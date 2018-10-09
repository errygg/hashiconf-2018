module "vault_ldap" {
  source = "./modules/terraform-aws-vault-ldap"
}

module "ssh_client_otp" {
  source         = "./modules/terraform-aws-ssh-client-otp"
  consul_version = ""
  consul_url     = ""
}

module "ssh_client_ca" {
  source          = "./modules/terraform-aws-ssh-client-ca"
  consul_version  = ""
  consul_url      = ""
  trusted_user_ca = ""
}