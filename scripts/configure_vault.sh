#!/bin/bash

# Run this script using root Vault token

# OTP users
echo "Configure web-developers namespace for SSH OTP users"
vault namespace create web-developers
export VAULT_NAMESPACE=web-developers

echo "Configure the ssh secrets engine for SSH OTP"
vault secrets enable ssh
vault policy write web-developers ./policies/web-developers.hcl

echo "Configure the auth backend for SSH OTP"
vault auth enable userpass
vault write -namespace=web-developers auth/userpass/users/bob password="password" policies=web-developers

# CA users
echo "Configure db-developers namespace for SSH CA users"
vault namespace create db-developers
export VAULT_NAMESPACE=db-developers

echo "Configure the ssh secrets engine for SSH CA"
vault secrets enable ssh
vault write ssh/config/ca generate_signing_key=true
vault policy write db-developers ./policies/db-developers.hcl

echo "Configure the auth backend for SSH CA"
vault auth enable userpass
vault write auth/userpass/users/suzy password="password" policies=db-developers
vault write ssh/roles/db-developers @./roles/db-developers.json
