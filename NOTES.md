# OTP

## Login as bob
> Control-b
> export VAULT_TOKEN=`vault login -token-only -method=userpass username=bob`

### Using password
> Control-p
> vault write ssh/creds/vampires ip=<IP>

> ssh bob@<IP>

### Using sshpass
> Control-v
> vault ssh -role=vampires -mode=otp -strict-host-key-checking=no bob@<IP>

# CA

## Login as suzy
> Control-u
> export VAULT_TOKEN=`vault login -token-only -method=userpass username=bob`

### Using write command
> Control-j
> vault write -field=signed_key ssh/sign/zombies public_key=@$HOME/.ssh/id_rsa.pub > ~/.ssh/id_rsa-cert.pub

> ssh suzy@<IP>

### Using vault ssh
> Control-g
> vault ssh -role=zombies -mode=otp suzy@<IP>

