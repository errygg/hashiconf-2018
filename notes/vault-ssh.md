# Vault SSH for DevOpsDays

## Setup

Available configurations: https://www.vaultproject.io/api/secret/ssh/index.html

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

Setup CA client

```
  > ./setup-ca-client.sh
```

Enable the Vault Certificate Authority

```
  > vault write ssh/config/ca generate_signing_key=true
```

Key pair can be specified if you have your own
Public key is accessible via the /public_key endpoint

### Add the CA key to a client

Typically the CA key would be added via some config management tool or
added via AWS cloud init, baked into the image/AMI, but not manually. So, we're
gonna add it manually...

```
  > curl -o /etc/ssh/trusted-user-ca-keys.pem http://172.18.0.2:8200/v1/ssh-client-signer/public_key
```
