# terraform-aws-ssh-client-ca Module

This module is used to build up an SSH CA client instance to use with the demo
for my talk at HashiConf 2018 - [Manage SSH with HashiCorp Vault]().

## Variables
| Name | Description |
|------|-------------|
| consul_version | Version of Consul to install |
| consul_url | URL of the Consul binary (OSS or enterprise) |
| trusted_user_ca | File contents of the Vault SSH CA |


## Outputs

| Name | Description |
|------|-------------|
| ca_client_public_ip | SSH CA Client Public IP Address |
