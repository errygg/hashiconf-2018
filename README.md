# Vault SSH for HashiConf 2018

This repo holds the notes, slides, and configurations for my talk at HashiConf 2018.

## Setup

The demo for this talk includes an enterprise versions of Vault and Consul using Terraform Enterprise (https://app.terraform.io) to setup all the infrastructure. More specifically, the following explains the setup:

* Terraform Enterprise is used to spin up the Vault/Consul clusters
* 3 node Vault Enterprise cluster with a 3 node Consul Enterprise cluster
* Vault is publicly accessible via AWS load balancer endpoint
* Consul is only accessible to Vault
* Script is used to setup the Vault SSH Secrets Engine and associated roles
* Terraform Enterprise is used to spin up the SSH clients in 2 separate workspaces

The Terraform workspace used to build the Vault/Consul cluster is located at: https://github.com/errygg/vault-guides/tree/master/operations/provision-vault/quick-start/terraform-aws.

> Note: This demo was performed using Terraform Enterprise; however, the same
demo can be accomplished using Terraform OSS using the `terraform` command in
place of the UI.

> Note: This demo uses configuration for Vault SSH found here: https://www.vaultproject.io/api/secret/ssh/index.html

### Spin up and Configure Vault

1. Run the terraform workspace to spin up the Vault/Consul cluster

2. Configure Vault via UI - 1 key share, 1 threshold

3. Download the keys & unseal with the master key

4. Run terraform to configure Vault SSH backend and users

```bash
  > cd ./scripts
  > . ./vault_env.sh <Vault URL> <JSON file downloaded from unsealing Vault>
  > ./configure_vault.sh
```

### OTP Client Admin Configuration

1. Spin up the OTP client via Terraform Enterprise

2. Create the OTP role for the `vampire` users as the root user

```bash
  > . ./scripts/vault_env.sh <VAULT_ADDR> <credentials json file>
  > vault write --namespace=vampires ssh/roles/vampires key_type=otp default_user=bob cidr_list="<IP address of OTP instance>/32"
```

### Login with Bob the Vampire

1. Authenticate with Vault as Bob

```bash
  > export VAULT_NAMESPACE=vampires
  > export VAULT_TOKEN=`vault login -token-only -method=userpass username=bob`
```

2. Get the OTP for the client

```bash
  > vault write ssh/creds/web-developers ip=<IP address of OTP instance>
```

3. SSH into the client

```bash
  > ssh bob@<IP address of OTP instance>
```

Enter the password from the `key` field in the write response from step 3.

4. `cat` out the PAM and ssh configs

```bash
  > cat /etc/pam.d/sshd
  > cat /etc/ssh/sshd_config
```

Exit out and try the password again and we'll see you can't login. OTP FTW!

### CA Client Admin Configuration

1. Spin up the CA client via Terraform Enterprise

### Login with Suzy

1. Authenticate with Vault

```bash
  > export VAULT_NAMESPACE=zombies
  > export VAULT_TOKEN=`vault login -token-only -method=userpass username=suzy`
```

2. Public key is accessible via the `/public_key` endpoint

```bash
  > curl http://<VAULT_ADDR>/v1/ssh/public_key
```

3. Test that we can't actually ssh to the node as Suzy

```bash
  > ssh suzy@<IP address of CA instance>
```

4. Sign the local ssh key, putting it next to the default key allows a simpler ssh command

```bash
  > vault write -field=signed_key ssh/sign/zombies public_key=@$HOME/.ssh/id_rsa.pub > ~/.ssh/id_rsa-cert.pub
  > chmod 600 ~/.ssh/id_rsa-cert.pub
```

5. SSH into the instance with our new signed key

```bash
  > ssh suzy@<IP address of CA instance>
```
