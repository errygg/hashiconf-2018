#
# Required Variables
#
variable "org" {
  description = "Terraform organization"
  type        = "string"
}

variable "trusted_user_ca" {
  description = "File contents of the Vault SSH CA"
  type        = "string"
}

variable "workspace" {
  description = "Terraform workspace"
  type        = "string"
}