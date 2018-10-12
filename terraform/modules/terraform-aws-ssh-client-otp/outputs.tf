output "otp_client_public_ip" {
  description = "SSH OTP Client Public IP Address"
  value       = "${aws_instance.otp_client.public_ip}"
}

output "otp_client_private_ip" {
  description = "SSH OTP Client Private IP Address"
  value       = "${aws_instance.otp_client.private_ip}"
}
