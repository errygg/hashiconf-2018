#
# Required Variables
#
variable "key_name" {
  description = "SSH key name"
  type        = "string"
}

variable "namespace" {
  description = "Namespace to use for SSH mount"
  type        = "string"
}

variable "subnet_id" {
  description = "Subnet ID to place this instance in"
  type        = "string"
}

variable "vpc_security_group_ids" {
  description = "Security group ID(s)"
  type        = "list"
}

#
# Optional Variables
#
variable "vault_addr" {
  description = "URL of the Vault server to do OTP lookups with"
  type        = "string"
  default     = "http://127.0.0.1:8200"
}
