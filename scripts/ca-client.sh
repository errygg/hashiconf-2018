#!/bin/bash
docker run -d -P --name ca-client -v $(pwd)/keys:/etc/ssh/trusted --network vault-net -p 2222:22 errygg/docker-vault-ssh-ca-client
