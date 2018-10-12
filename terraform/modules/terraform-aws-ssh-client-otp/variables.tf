#
# Required Variables
#
variable "subnet_id" {
  description = "Subnet ID to place this instance in"
  type        = "string"
}

variable "vpc_security_group_ids" {
  description = "Security group ID(s)"
  type        = "list"
}

variable "workspace" {
  description = "Workspace to use for SSH mount"
  type        = "string"
}

variable "key_name" {
  description = "Name of the key pair to use"
  type        = "string"
}

#
# Optional Variables
#
variable "vault_addr" {
  description = "URL of the Vault server to do OTP lookups with"
  type        = "string"
  default     = "http://127.0.0.1:8200"
}
