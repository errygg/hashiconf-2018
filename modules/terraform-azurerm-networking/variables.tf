variable "enable_nomad" {
  description = "Boolean to enable Nomad"
  default     = false
}

variable "enable_consul" {
  description = "Boolean to enable Consul"
  default     = false
}

variable "enable_vault" {
  description = "Boolean to enable Vault"
  default     = false
}

variable "location" {
  description = "Location (Region) of Azure"
}

variable "namespace" {
  description = "Unique namespace for resource group names"
}

variable "network_space" {
  description = "VNet CIDR"
}

variable "tags" {
  description = "Optional map of tags to set on resources, defaults to empty map."
  type        = "map"
  default     = {}
}
