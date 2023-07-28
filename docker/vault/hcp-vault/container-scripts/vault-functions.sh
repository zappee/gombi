#!/bin/bash -ue
# ******************************************************************************
# Functions that helps to manage ForgeRock Directory Server.
#
# Since : January, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
source /shared.sh

# ----------------------------------------------------------------------------
# Get the root token value.
# ------------------------------------------------------------------------------
function get_vault_root_token() {
  local root_token
  root_token=$(grep "Initial Root Token" /var/log/vault-tokens.txt |  awk '{ print $4 }')
  printf "%s" "$root_token"
}

# ----------------------------------------------------------------------------
# Get the root token value.
#
#  Arguments:
#     arg 1: the number of the key to retrieve
# ------------------------------------------------------------------------------
function get_vault_unseal_key() {
  local key_id key
  key_id="$1"
  key=$(grep "Unseal Key $key_id" /var/log/vault-tokens.txt |  awk '{ print $4 }')
  printf "%s" "$key"
}

# ----------------------------------------------------------------------------
# Start HashiCorp Vault.
# ------------------------------------------------------------------------------
function start_vault() {
  local fqdn vault_log vault_address vault_cacert
  fqdn=$(hostname -f)
  vault_log="/var/log/vault.log"
  vault_address="https://$fqdn:$VAULT_API_PORT"
  vault_cacert="$KEYSTORE_HOME/ca.pem"

  printf "%s | [INFO]  starting HashiCorp Vault...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  printf "%s | [DEBUG]             fqdn: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$fqdn"
  printf "%s | [DEBUG]      config file: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$VAULT_CONFIG_FILE"
  printf "%s | [DEBUG]         log file: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$vault_log"
  printf "%s | [DEBUG]         api port: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$VAULT_API_PORT"
  printf "%s | [DEBUG]    vault address: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$vault_address"
  printf "%s | [DEBUG]     vault cacert: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$vault_cacert"
  
  export VAULT_ADDR="$vault_address"
  export VAULT_CACERT="$vault_cacert"
  vault server -config="$VAULT_CONFIG_FILE" 2>&1 | tee "$vault_log" &
  
  while ! nc -w 5 -z "localhost" "$VAULT_API_PORT" 2>/dev/null; do
    sleep 0.5
  done

  printf "%s | [INFO]  HashiCorp Vault has been started\n" "$(date +"%Y-%b-%d %H:%M:%S")"
}

# ----------------------------------------------------------------------------
# Stop HashiCorp Vault.
# ------------------------------------------------------------------------------
function stop_vault() {
  printf "%s | [INFO]  stoppling HashiCorp Vault...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  /bin/bash -c '/usr/bin/killall -q vault; exit 0'
  printf "%s | [INFO]  HashiCorp Vault has been stopped\n" "$(date +"%Y-%b-%d %H:%M:%S")"
}
