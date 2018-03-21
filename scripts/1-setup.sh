#!/bin/bash
# Cleanup old objects
docker container stop test-vault-server
docker container prune -f
docker network rm vault-net
unset VAULT_ADDR
unset VAULT_TOKEN

# Setup new objects
docker network create vault-net
docker run --name test-vault-server --network vault-net --cap-add=IPC_LOCK -e 'VAULT_DEV_ROOT_TOKEN_ID=token_id' -p 8200:8200 -d vault
