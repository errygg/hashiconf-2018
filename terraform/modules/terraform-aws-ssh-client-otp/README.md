# terraform-aws-ssh-client Module

This module is used to build up an SSH one-time password client instance to use
with the demo for my talk at HashiConf 2018 -
[Manage SSH with HashiCorp Vault]().

## Variables
| Name | Description |
|------|-------------|
| consul_version | Version of Consul to install |
| consul_url | URL of the Consul binary (OSS or enterprise) |

## Outputs

| Name | Description |
|------|-------------|
| otp_client_public_ip | SSH OTP Client Public IP Address |