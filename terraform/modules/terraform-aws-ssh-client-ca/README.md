# terraform-aws-ssh-client-ca Module

This module is used to build up an SSH CA client instance to use with the demo
for my talk at HashiConf 2018 - [Manage SSH with HashiCorp Vault]().

## Variables
| Name | Description |
|------|-------------|
| key_name | SSH key name |
| subnet_id | Subnet ID to place this instance in |
| trusted_user_ca | File contents of the Vault SSH CA |
| vpc_security_group_ids | Security group ID(s) |


## Outputs

| Name | Description |
|------|-------------|
| ca_client_public_ip | SSH CA Client Public IP Address |
