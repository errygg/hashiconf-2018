# Vault SSH for HashiConf 2018

This repo holds the notes, slides, and configurations for my talk at HashiConf 2018.

## Setup

The demo for this talk includes an enterprise versions of Vault and Consul using Terraform Enterprise (https://app.terraform.io) to setup all the infrastructure. More specifically, the following explains the setup:

* Vault and Consul talk to each other using TLS
* 3 node Vault cluster with a 3 node Consul cluster
* Vault is publicly accessible via AWS load balancer endpoint
* Consul is only accessible to Vault

The Terraform workspace used to build the Vault/Consul cluster is located at: https://github.com/errygg/vault-guides/tree/master/operations/provision-vault/quick-start/terraform-aws. The following is a screenshot of the variables set for this project:

TODO: screenshot of Terraform Enterprise variables in the `secrets-aws-dev-us-west-2` workspace

Additionally, the modules in this repo were created to connect the Vault LDAP backend to [JumpCloud](https://jumpcloud.com/). This module uses resources in the [JumpCloud Terraform module](https://github.com/geekmuse/terraform-provider-jumpcloud) to create users in LDAP. 

### OTP Client


### CA Client

## Vault

### Authentication

Authentication for users is done using JumpCloud LDAP. In order to login to Vault ensure a username and password are created in JumpCloud (should be setup with the the module inside this repo).

To login via LDAP credentials:

```bash
  > export VAULT_ADDRESS=(load_balancer_address_from_TFE_outputs)
  TODO: setup the rest here
```

### SSH Secrets Engine

Available configurations for OTP or CA roles: https://www.vaultproject.io/api/secret/ssh/index.html

Show the server is up

```bash
  > vault status
```

Enable the ssh Secret engine backend (explain Vault engines)

```bash
  > vault secrets enable ssh
```

#### SSH OTP

Bring up a client node (show Docker file, explain config)

```
  > ./otp-client.sh
```

Try to ssh to show we can't

```
  > ssh ubuntu@localhost -p 2223
```


Create a Vault role for the ubuntu user (explain Vault roles)

```
  > vault write ssh/roles/otp_role\
    key_type=otp\
    default_user=ubuntu\
    cidr_list=172.18.0.0/16
```

Get the OTP

```
  > vault write ssh/creds/otp_role ip=172.18.0.3
```

ssh into the client

```
  > docker port otp-client
  > ssh ubuntu@localhost -p 2223
```

Enter the password from the `key` field in the write response above

Take a look at the PAM config

```
  > cat /etc/pam.d/sshd
```

Exit out and try the password again and we'll see you can't login. OTP baby!

#### SSH CA

Enable the Vault Certificate Authority

```
  > vault write ssh/config/ca generate_signing_key=true
```

You can also specify your own private and public keys if you'd like

Public key is accessible via the `/public_key` endpoint

```
  > curl http://localhost:8200/v1/ssh/public_key
```

##### Add the CA key to a client

Typically the CA key would be added via some config management tool or
added via AWS cloud init, baked into the image/AMI, etc. We are gonna copy the
file into a Vagrant VM.

```
  > cd devopsdays-denver-2018/scripts/
  > vault read -field=public_key ssh/config/ca > trusted-user-ca-keys.pem
```

Now we'll bring up the CA client

```
  > ./ca-client.sh
```

Test that we can't actually ssh to the node via the ubuntu user

```
  > ssh ubuntu@localhost -p 2222
```

Create a role

```
  > vault write ssh/roles/user-role @roles/user-role.json
  > vault read ssh/roles/user-role
```

##### Sign the local ssh key

We'll just write the signed key to a file

```
  > vault write -field=signed_key ssh/sign/user-role public_key=@$HOME/.ssh/id_rsa.pub > ~/.ssh/id_rsa-cert.pub
  > chmod 600 ~/.ssh/id_rsa-cert.pub
```

##### Login

SSH into the instance with our new signed key

```
  > ssh ubuntu@localhost -p <port>
```
