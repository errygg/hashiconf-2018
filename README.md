# Vault SSH for DevOpsDays

## Setup

Available configurations for OTP or CA roles: https://www.vaultproject.io/api/secret/ssh/index.html

First, cleanup old items from prior testing

```
  > ./cleanup.sh
```

Run some setup scripts

```
  > ./setup-server.sh
  > . ./setup-env.sh
```

Show the server is up

```
  > vault status
```

Enable the ssh Secret engine backend (explain Vault engines)

```
  > vault secrets enable ssh
```

## SSH OTP

Bring up a client node (show Docker file, explain config)

```
  > ./otp-client.sh
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
  > ssh ubuntu@localhost -p <port>
```

Enter the password from the `key` field in the write response above

Take a look at the PAM config

```
  > cat /etc/ssh/sshd_config
```

Exit out and try the password again and we'll see you can't login. OTP baby!

## SSH CA

Enable the Vault Certificate Authority

```
  > vault write ssh/config/ca generate_signing_key=true
```

You can also specify your own private and public keys if you'd like

Public key is accessible via the /public_key endpoint

```
  > curl http://localhost:8200/v1/ssh/public_key
```

### Add the CA key to a client

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
  > vagrant port
  > ssh ubuntu@localhost -p 2222
```

Create a role

```
  > vault write ssh/roles/user-role @roles/user-role.json
  > vault read ssh/roles/user-role
```

### Sign the local ssh key

Lets take a look at the signed public key and the serial number

```
  > vault write ssh/sign/user-role public_key=@$HOME/.ssh/id_rsa.pub
```

Now we'll just write the signed key to a file

```
  > vault write -field=signed_key ssh/sign/user-role public_key=@$HOME/.ssh/id_rsa.pub > ~/.ssh/id_rsa-cert.pub
  > chmod 600 ~/.ssh/id_rsa-cert.pub
```

### Login

SSH into the instance with our new signed key

```
  > ssh ubuntu@localhost -p <port>
```
