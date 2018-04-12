#!/bin/bash
docker run -d -P --name ca-client --network vault-net -p 2222:22 --env CERT='curl http://localhost:8200/v1/ssh-client-signer/public_key' errygg/docker-vault-ssh-ca-client
