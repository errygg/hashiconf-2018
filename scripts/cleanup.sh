#!/bin/bash
# Cleanup old objects
docker container stop vault-server
docker container stop otp-client
docker container prune -f
docker network rm vault-net
vagrant destroy
unset VAULT_ADDR
unset VAULT_TOKEN
rm -rf trusted-user-ca-keys.pem
rm -rf ~/.ssh/known_hosts
rm -rf ~/.ssh/id_rsa-cert.pub
