#!/bin/bash -ue
# ******************************************************************************
# Functions that helps to manage HashiCorp Vault.
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
  root_token=$(grep "Initial Root Token" "$VAULT_INIT_LOG" |  awk '{ print $4 }')
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
  key=$(grep "Unseal Key $key_id" "$VAULT_INIT_LOG" |  awk '{ print $4 }')
  printf "%s" "$key"
}

# ----------------------------------------------------------------------------
# Start HashiCorp Vault.
# ------------------------------------------------------------------------------
function start_vault() {
  printf "%s | [INFO]  starting HashiCorp Vault...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  
  local fqdn vault_log vault_address vault_cacert
  fqdn=$(hostname -f)
  vault_log="/var/log/vault.log"
  vault_cacert="$KEYSTORE_HOME/ca.pem"
  vault_address="https://$fqdn:$VAULT_API_PORT"

  printf "%s | [DEBUG]                 fqdn: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$fqdn"
  printf "%s | [DEBUG]    VAULT_CONFIG_FILE: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$VAULT_CONFIG_FILE"
  printf "%s | [DEBUG]             log file: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$vault_log"
  printf "%s | [DEBUG]       VAULT_API_PORT: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$VAULT_API_PORT"
  printf "%s | [DEBUG]         VAULT_CACERT: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$vault_cacert"
  printf "%s | [DEBUG]           VAULT_ADDR: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$vault_address"
  
  export VAULT_CACERT="$vault_cacert"
  export VAULT_ADDR="$vault_address"
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


# ----------------------------------------------------------------------------
# Unseal Vault.
#
# Vault starts in a sealed state. It cannot perform operations until it is
# unsealed.
#
#  Arguments:
#     arg 1: unseal key
# ------------------------------------------------------------------------------
function unseal_vault() {
  local unseal_key
  unseal_key="$1"

  printf "%s | [INFO]  unsealing HashiCorp Vault using \"%s\" as an unseal key...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$unseal_key"
  vault operator unseal "$unseal_key"
}
