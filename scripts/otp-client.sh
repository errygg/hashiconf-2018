#!/bin/bash
docker run -d -P --name otp-client --network vault-net -p 2223:22 errygg/vault-ssh-helper
