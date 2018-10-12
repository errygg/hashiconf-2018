# Vault SSH for HashiConf 2018

This repo holds the notes, slides, and configurations for my talk at HashiConf 2018.

## Setup

The demo for this talk includes an enterprise versions of Vault and Consul using Terraform Enterprise (https://app.terraform.io) to setup all the infrastructure. More specifically, the following explains the setup:

* 3 node Vault cluster with a 3 node Consul cluster
* Vault is publicly accessible via AWS load balancer endpoint
* Consul is only accessible to Vault
* Terraform is used to setup the Vault LDAP configuration
* Terraform is used to setup the Vault SSH Secrets Engine and associated roles

The Terraform workspace used to build the Vault/Consul cluster is located at: https://github.com/errygg/vault-guides/tree/master/operations/provision-vault/quick-start/terraform-aws. The following is a screenshot of the variables set for this project:

TODO: screenshot of Terraform Enterprise variables in the `secrets-aws-dev-us-west-2` workspace

> Note: This demo uses resources in the [JumpCloud Terraform module](https://github.com/geekmuse/terraform-provider-jumpcloud) to create users in LDAP.

> Note: This demo was performed using Terraform Enterprise; however, the same
demo can be accomplished using Terraform OSS using the `terraform` command in
place of `tfe-cli` command or UI.

This demo uses configuration for Vault SSH found here: https://www.vaultproject.io/api/secret/ssh/index.html

### Configure Vault

1. Run terraform to configure the SSH engine and LDAP authentication

```bash
  > cd ./terraform
  > export JUMPCLOUD_API_TOKEN=""
  > tfe-cli plan --target=module.vault_ldap
```

### OTP Client
TODO: run these commands via the Terraform Enterprise CLI

1. Spin up the OTP client

```bash
  > cd ./terraform
  > tfe plan --target=module.ssh_client_otp
  > tfe apply --target=module.ssh_client_otp
```

2. Authenticate with Vault using LDAP

```bash
  > export VAULT_ADDR=""
  > export VAULT_TOKEN=`vault login -method=ldap -username=errygg -token-only`
```

3. Get the OTP for the client

```bash
  > vault write ssh/creds/otp_role ip="<public_ip_address_for_otp_client>"
```

4. SSH into the client

```bash
  > ssh ubuntu@<public_ip_address_for_otp_client>
```

Enter the password from the `key` field in the write response from step 3.

5. `cat` out the PAM config

```bash
  > cat /etc/pam.d/sshd
```

Exit out and try the password again and we'll see you can't login. OTP baby!

### CA Client
TODO: run the Terraform steps in the Terraform UI, show screenshots

1. Authenticate with Vault using LDAP

```bash
  > export VAULT_ADDR=""
  > export VAULT_TOKEN=`vault login -method=ldap -username=errygg`
```

2. Public key is accessible via the `/public_key` endpoint

```bash
  > curl http://localhost:8200/v1/ssh/public_key
```

3. Spin up the CA client (this will pull in this new public_key via User Data)

```bash
  > cd ./terraform
  > tfe-cli plan --target=module.ssh_client_ca
  > tfe-cli apply --target=module.ssh_client_ca
```

> Note: The CA can be added via configuration management as well, here we are
using AWS user data.

4. Test that we can't actually ssh to the node via the ubuntu user

```bash
  > ssh ubuntu@<public_ip_for_ca_client>
```

6. Sign the local ssh key

```bash
  > vault write -field=signed_key ssh/sign/user-role public_key=@$HOME/.ssh/id_rsa.pub > ~/.ssh/id_rsa-cert.pub
  > chmod 600 ~/.ssh/id_rsa-cert.pub
```

7. SSH into the instance with our new signed key

```bash
  > ssh ubuntu@<public_ip_for_ca_client>
```
