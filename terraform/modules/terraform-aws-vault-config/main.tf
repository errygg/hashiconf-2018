provider "vault" {}

provider "jumpcloud" {
  api_key = "${var.jumpcloud_api_key}"
}

# TODO: configure Vault SSH Secrets Engine

# TODO: create JumpCloud user

# TODO: configure Vault LDAP Authentication with new JumpCloud user

# TODO: create role for CA and OTP
