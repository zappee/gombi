#!/bin/bash -ue
# ******************************************************************************
# Functions that helps to manage ForgeRock Directory Server.
#
# Since : January, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************

# ------------------------------------------------------------------------------
# Restore the ForgeRock Directory Server configuration from a backup file.
# ------------------------------------------------------------------------------
function restore_ds_config() {
  local backup_file
  backup_file="$DS_HOME/backup/$CONFIG_RESTORE_FROM"

  if [[ -f "$backup_file" ]]; then
    printf "%s | [INFO]  restoring server configuration from \"%s\" file...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$backup_file"
    stop_ds
    tar -xvf "$backup_file" -C "$DS_HOME"
    printf "%s | [INFO]  server configuration has been restored\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  else
    printf "%s | [WARN]  the provided backup file does not exist: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$backup_file"
  fi
}

# ------------------------------------------------------------------------------
# Restore LDAP data from a backup file.
# ------------------------------------------------------------------------------
function restart_ds_ldap() {
  local backup_file fqdn
  backup_file="$DS_HOME/backup/$LDAP_RESTORE_FROM"
  fqdn=$(hostname -f)

  # the keystore cen bu used as a truststore too because it contains the CA certificate as well
  local keystore_file keystore_password
  keystore_file="/tmp/$fqdn.p12"
  keystore_password="changeit"

  if [[ -f "$backup_file" ]]; then
    printf "%s | [INFO]  restoring the LDAP database from \"%s\" file...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$backup_file"
    printf "%s | [DEBUG]   directory service home: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$DS_HOME"
    printf "%s | [DEBUG]              backup file: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$backup_file"
    printf "%s | [DEBUG]             ldap user DN: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$LDAP_USER_DN"
    printf "%s | [DEBUG]       ldap user password: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$LDAP_USER_PASSWORD"
    printf "%s | [DEBUG]                 hostname: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$fqdn"
    printf "%s | [DEBUG]     admin connector port: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$ADMIN_CONNECTOR_PORT"
    printf "%s | [DEBUG]            keystore file: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$keystore_file"
    printf "%s | [DEBUG]        keystore password: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$keystore_password"
    start_ds
    printf "%s | [DEBUG] unpacking the backup files...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
    tar -xvf "$backup_file" -C "$DS_HOME"
    "$DS_HOME/bin/dsbackup" restore \
            --hostname "$fqdn" \
            --port "$ADMIN_CONNECTOR_PORT" \
            --bindDN "$LDAP_USER_DN" \
            --bindPassword "$LDAP_USER_PASSWORD" \
            --backendName amIdentityStore \
            --backupLocation "$DS_HOME/bak" \
            --no-prompt \
            --usePkcs12KeyStore "$keystore_file" \
            --keyStorePassword "$keystore_password" \
            --certNickname "$fqdn" \
            --usePkcs12TrustStore "$keystore_file" \
            --trustStorePassword "$keystore_password"
    printf "%s | [INFO]  LDAP database has been restored\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  else
    printf "%s | [WARN]  the provided backup file does not exist: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$backup_file"
  fi
}

# ------------------------------------------------------------------------------
# Restore the server state.
# If the server was stopped before the backup process then this will stop the
# running server.
#
# Arguments
#    arg 1:  server state before the backup process had been executed
#               true: server was in running before the backup
#    arg 2:  ignore the previous server state and does not update the server
#            status
# ------------------------------------------------------------------------------
function restore_ds_server_state() {
  local run_before_backup ignore_previous_state
  run_before_backup="$1"
  ignore_previous_state="${2:-false}"

  if [ "$run_before_backup" == "false" ]; then
    if [ "$run_before_backup" == "true" ]; then
      start_ds
    else
      stop_ds
    fi
  fi
}

# ------------------------------------------------------------------------------
# Backup the ForgeRock Directory Server configuration.
#
# Arguments
#    arg 1:  ignore the previous server state and does not update the server
#            status
# ------------------------------------------------------------------------------
function backup_ds_config() {
  local ignore_previous_state run_before_backup timestamp backup_file
  ignore_previous_state="$1"
  run_before_backup=$(get_server_state)
  timestamp="$(date "+%Y-%m-%d_%H.%M.%S")"
  backup_file="$DS_HOME/backup/ds-config_$timestamp.tar.gz"

  printf "%s | [INFO]  backing up ForgeRock Directory Server configuration...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  if [ "$run_before_backup" == "true" ]; then
    stop_ds
  fi

  tar -czvf "$backup_file" --directory="$DS_HOME" config/

  printf "%s | [DEBUG] server configuration backup file: %s\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$backup_file"
  printf "%s | [INFO]  configuration files has been backed up\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  restore_ds_server_state "$run_before_backup" "$ignore_previous_state"
}

# ------------------------------------------------------------------------------
# Backup LDAP data.
# Arguments
#    arg 1:  backend name, for example: 'am-config', 'am-identity-store',
#            'schema' or 'tasks'
# ------------------------------------------------------------------------------
function backup_ds_data() {
  printf "%s | [INFO]  backing up ForgeRock Directory Server LDAP database...\n" "$(date +"%Y-%b-%d %H:%M:%S")"

  local run_before_backup
  run_before_backup=$(get_server_state)
  if [ "$run_before_backup" == "false" ]; then
    start_ds
  fi

  local fqdn
  fqdn=$(hostname -f)

  # the keystore cen bu used as a truststore too because it contains the CA certificate as well
  local keystore_file keystore_password
  keystore_file="/tmp/$fqdn.p12"
  keystore_password="changeit"

  local backend_name timestamp backup_file
  backend_name="$1"
  timestamp="$(date "+%Y-%m-%d_%H.%M.%S")"
  backup_file="${DS_HOME}/backup/ds-ldap_${backend_name}_${timestamp}.tar.gz"
  

  printf "%s | [DEBUG]   directory service home: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$DS_HOME"
  printf "%s | [DEBUG]             backend name: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$backend_name"
  printf "%s | [DEBUG]              backup file: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$backup_file"
  printf "%s | [DEBUG]             ldap user DN: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$LDAP_USER_DN"
  printf "%s | [DEBUG]       ldap user password: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$LDAP_USER_PASSWORD"
  printf "%s | [DEBUG]                 hostname: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$fqdn"
  printf "%s | [DEBUG]     admin connector port: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$ADMIN_CONNECTOR_PORT"
  printf "%s | [DEBUG]            keystore file: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$keystore_file"
  printf "%s | [DEBUG]        keystore password: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$keystore_password"

  rm -rf "$DS_HOME"/bak/*
  "$DS_HOME/bin/dsbackup" create \
    --hostname "$fqdn" \
    --port "$ADMIN_CONNECTOR_PORT" \
    --bindDN "$LDAP_USER_DN" \
    --bindPassword "$LDAP_USER_PASSWORD" \
    --backendName "$backend_name" \
    --backupLocation "$DS_HOME/bak" \
    --no-prompt \
    --usePkcs12KeyStore "$keystore_file" \
    --keyStorePassword "$keystore_password" \
    --certNickname "$fqdn" \
    --usePkcs12TrustStore "$keystore_file" \
    --trustStorePassword "$keystore_password"

  tar -czvf "$backup_file" --directory="$DS_HOME" bak/
  printf "%s | [INFO]  LDAP database has been backed up\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  restore_ds_server_state "$run_before_backup"
}

# ------------------------------------------------------------------------------
# Get the sate of the ForgeRock Directory Server.
# ------------------------------------------------------------------------------
function get_server_state() {
  local fqdn
  fqdn=$(hostname -f)

  "$DS_HOME/bin/status" \
      --hostname "$fqdn" \
      --port "$ADMIN_CONNECTOR_PORT" \
      --bindDn "$LDAP_USER_DN" \
      --bindPassword "$LDAP_USER_PASSWORD" \
      --trustAll \
      > /dev/null 2>&1

  if [ $? -eq 0 ]; then
    printf "true"
  else
    printf "false"
  fi
}

# ------------------------------------------------------------------------------
# Start the ForgeRock Directory Server.
# ------------------------------------------------------------------------------
function start_ds() {
  if [ "$(get_server_state)" == "false" ]; then
    printf "%s | [DEBUG] removing previous lock files...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
    rm -vf "$DS_HOME"/locks/*
    printf "%s | [INFO]  starting the LDAP server...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
    "$DS_HOME/bin/start-ds"
  fi
}

# ------------------------------------------------------------------------------
# Stop the ForgeRock Directory Server.
# ------------------------------------------------------------------------------
function stop_ds() {
  if [ "$(get_server_state)" == "true" ]; then
    "$DS_HOME/bin/stop-ds"
  else
    printf "%s | [INFO]  LDAP server stopped\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  fi
}
