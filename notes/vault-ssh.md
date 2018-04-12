# Vault SSH for DevOpsDays

## Setup

Available configurations for OTP or CA roles: https://www.vaultproject.io/api/secret/ssh/index.html

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

ssh into the client

```
  > ssh ubuntu@localhost -p <port>
```

## SSH CA

Enable the Vault Certificate Authority

```
  > vault write ssh/config/ca generate_signing_key=true
```

Key pair can be specified if you have your own

To do so you'd run:
```
  > vault write ssh/config/ca private_key=your_private_key public_key=your_public_key
```

Public key is accessible via the /public_key endpoint

```
  > curl http://localhost:8200/v1/ssh/public_key
```

### Add the CA key to a client

Typically the CA key would be added via some config management tool or
added via AWS cloud init, baked into the image/AMI, etc. We are gonna use a
local directory and mount it to the Docker container.

```
  > cd devopsdays-denver-2018/scripts
  > mkdir keys
  > vault read -field=public_key ssh/config/ca > keys/trusted-user-ca-keys.pem
```

Now we'll bring up the CA client:
```
  > ./ca-client.sh
```

Create a role:
```
  > vault write ssh/roles/user-role @roles/user-role.json
  > vault read ssh/roles/user-role
```

### Sign the local ssh key

Lets take a look at the signed public key and the serial number
```
  > vault write ssh/sign/user-role public_key=@$HOME/.ssh/id_rsa.pub
```

Now we'll just write the signed key to a file, this file name will automatically
be used by OpenSSH (pretty cool)
```
  > vault write -field=signed_key ssh/sign/user-role public_key=@$HOME/.ssh/id_rsa.pub > ~/.ssh/id_rsa-cert.pub
  > chmod 600 ~/.ssh/id_rsa-cert.pub
```
