output "otp_client_public_ip" {
  description = "SSH OTP Client Public IP Address"
  value       = "${aws_instance.otp_client.public_ip}"
}

output "ca_client_public_ip" {
  description = "SSH CA Client Public IP Address"
  value       = "${aws_instance.ca_client.public_ip}"
}