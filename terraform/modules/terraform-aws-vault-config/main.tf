provider "vault" {}

resource "vault_auth_backend" "userpass" {
  type        = "userpass"
  description = "Enable `userpass` authentication"
}

resource "vault_mount" "ssh" {
  type        = "ssh"
  description = "SSH Vault Mount"
}
