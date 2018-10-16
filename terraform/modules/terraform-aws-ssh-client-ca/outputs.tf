output "ca_client_private_ip" {
  description = "SSH CA Client Private IP Address"
  value       = "${aws_instance.ca_client.private_ip}"
}

output "ca_client_public_ip" {
  description = "SSH CA Client Public IP Address"
  value       = "${aws_instance.ca_client.public_ip}"
}
