# terraform-aws-ssh-client Module

This module is used to build up an SSH one-time password client instance to use
with the demo for my talk at HashiConf 2018 -
[Manage SSH with HashiCorp Vault]().

## Variables
| Name | Description |
|------|-------------|
| key_name | SSH key name |
| subnet_id | Subnet ID to place this instance in |
| vault_addr | URL of the Vault server to do OTP lookups with |
| vpc_security_group_ids | Security group ID(s) |
| workspace | Workspace to use for SSH mount |

## Outputs

| Name | Description |
|------|-------------|
| otp_client_public_ip | SSH OTP Client Public IP Address |