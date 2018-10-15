#
# Required Variables
#
variable "allowed_cidrs" {
  description = "CIDR addresses allowed by Vault (comma-delimited list)"
  type        = "string"
  default     = "false"
}

variable "allowed_roles" {
  description = "Vault roles allowed to ssh to this instance (comma-delimited list)"
  type        = "string"
}

variable "key_name" {
  description = "Name of the key pair to use"
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
