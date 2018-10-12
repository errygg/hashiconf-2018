#
# Required Variables
#
variable "key_name" {
  description = "SSH key name"
  type        = "string"
}

variable "subnet_id" {
  description = "Subnet ID to place this instance in"
  type        = "string"
}

variable "trusted_user_ca" {
  description = "File contents of the Vault SSH CA"
  type        = "string"
}

variable "vpc_security_group_ids" {
  description = "Security group ID(s)"
  type        = "list"
}
