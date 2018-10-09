#
# Required Variables
#
variable "consul_version" {
  description = "Version of Consul to install"
}

variable "consul_url" {
  description = "URL of the Consul binary (OSS or enterprise)"
}

variable "trusted_user_ca" {
  description = "File contents of the Vault SSH CA"
}

#
# Optional Variables
#
