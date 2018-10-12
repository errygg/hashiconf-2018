#!/bin/bash

# Arg 1 is the Vault Address
# Arg 2 is the downloaded keys file from Vault

export VAULT_ADDR=$1
export VAULT_TOKEN=`cat ${2} |jq -r .root_token`
