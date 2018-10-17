#!/bin/bash

# Run this script using root Vault token

unset VAULT_NAMESPACE

# OTP users
echo "Configure vampires namespace for SSH OTP users"
vault namespace create vampires
export VAULT_NAMESPACE=vampires

echo "Configure the ssh secrets engine for SSH OTP"
vault secrets enable ssh
vault policy write vampires ./policies/vampires.hcl

echo "Configure the auth backend for SSH OTP"
vault auth enable userpass
vault write auth/userpass/users/bob password="password" policies=vampires

unset VAULT_NAMESPACE

# CA users
echo "Configure zombies namespace for SSH CA users"
vault namespace create zombies
export VAULT_NAMESPACE=zombies

echo "Configure the ssh secrets engine for SSH CA"
vault secrets enable ssh
vault write ssh/config/ca generate_signing_key=true
vault policy write zombies ./policies/zombies.hcl

echo "Configure the auth backend for SSH CA"
vault auth enable userpass
vault write auth/userpass/users/suzy password="password" policies=zombies
vault write ssh/roles/zombies @./roles/zombies.json
