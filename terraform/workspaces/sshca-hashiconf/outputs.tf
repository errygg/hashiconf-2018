output "ca_client_public_ip" {
  description = "SSH CA Client Public IP Address"
  value       = "${module.ssh_client_ca.ca_client_public_ip}"
}