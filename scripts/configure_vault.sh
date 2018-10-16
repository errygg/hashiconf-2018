#!/bin/bash

# Run this script using root Vault token

# OTP users
echo "Configure web-developers as SSH OTP users"
vault namespace create web-developers
vault secrets enable -namespace=web-developers ssh

vault policy write -namespace=web-developers web-developers ./policies/web-developers.hcl
vault auth enable -namespace=web-developers userpass
vault write -namespace=web-developers auth/userpass/users/bob password="password" policies=web-developers

# CA users
echo "Configure db-developers as SSH CA users"
vault namespace create db-developers
vault secrets enable -namespace=db-developers ssh
vault write -namespace=db-developers ssh/config/ca generate_signing_key=true

vault policy write -namespace=db-developers db-developers ./policies/db-developers.hcl
vault auth enable -namespace=db-developers userpass
vault write -namespace=db-developers auth/userpass/users/suzy password="password" policies=db-developers
