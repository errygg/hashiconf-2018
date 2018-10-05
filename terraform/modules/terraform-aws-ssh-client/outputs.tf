output "otp_client_public_ip" {
  value = "${aws_instance.otp_client.public_ip}"
}