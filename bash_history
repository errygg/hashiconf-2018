export VAULT_TOKEN=`vault login -token-only -method=userpass username=bob`
export VAULT_TOKEN=`vault login -token-only -method=userpass username=suzy`
vault write -field=signed_key ssh/sign/zombies public_key=@$HOME/.ssh/id_rsa.pub > ~/.ssh/id_rsa-cert.pub
