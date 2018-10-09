output "otp_client_public_ip" {
  value = "${module.ssh_clients.otp_client_public_ip}"
}

output "ca_client_public_ip" {
  value = "${module.ssh_clients.ca_client_public_ip}"
}