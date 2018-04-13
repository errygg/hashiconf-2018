#!/bin/bash
# Setup new objects
docker network create vault-net
docker run --name vault-server --network vault-net --cap-add=IPC_LOCK -e 'VAULT_DEV_ROOT_TOKEN_ID=token_id' -p 8200:8200 -d vault:0.9.6
