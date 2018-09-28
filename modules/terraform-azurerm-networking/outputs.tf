output "consul_lb_public_ip" {
  description = "Public IP address of the Consul load balancer (blank if `enable_consul=false`)"
  value       = "azurerm_public_ip.consul.*.ip_address"
}

output "nomad_lb_public_ip" {
  description = "Public IP address of the Nomad load balancer (blank if `enable_nomad=false`)"
  value       = "azurerm_public_ip.nomad.*.ip_address"
}

output "vault_lb_public_ip" {
  description = "Public IP address of the Vault load balancer (blank if `enable_vault=false`)"
  value       = "azurerm_public_ip.vault.*.ip_address"
}
