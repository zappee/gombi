#!/bin/bash -ue
# ******************************************************************************
#  Shared, common bash functions.
#
#  Since : April, 2023
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************

# ------------------------------------------------------------------------------
#  Copy file(s) from a remote machine to localhost.
#
# Arguments
#    arg 1:  remote host
#    arg 2:  user on the remote host
#    arg 3:  password for the connecting user
#    arg 4:  path to the file on the remote machine
#    arg 5:  directory on the local machine where the file will be copied
# ------------------------------------------------------------------------------
function copy_from_remote_machine() {
  local remote_host remote_user remote_password remote_path local_path
  remote_host="$1"
  remote_user="$2"
  remote_password="$3"
  remote_path="$4"
  local_path="$5"

  printf "%s | [DEBUG] scp %s@%s:%s %s\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$remote_user" "$remote_host" "$remote_path" "$local_path"
  sshpass -p "$remote_password" scp \
    -o StrictHostKeyChecking=no \
    -o ConnectTimeout=2 \
    -o ConnectionAttempts=5 \
    "$remote_user@$remote_host:$remote_path" "$local_path"
}

# ------------------------------------------------------------------------------
# This method generates a certificate for the server using the our Private
# Certificate Authority infrastructure.
#
# Arguments
#    arg 1:  the hostname for which the certificate is generated
# ------------------------------------------------------------------------------
function generate_certificate() {
  local host_name
  host_name="$1"

  printf "%s | [INFO]  generating a server certificate...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  printf "%s | [DEBUG]         CA_HOST: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$CA_HOST"
  printf "%s | [DEBUG]        SSH_USER: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$SSH_USER"
  printf "%s | [DEBUG]    SSH_PASSWORD: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$SSH_PASSWORD"
  printf "%s | [DEBUG]       host_name: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$host_name"
  sshpass -p "$SSH_PASSWORD" ssh \
    -oStrictHostKeyChecking=no \
    "$SSH_USER@$CA_HOST" "bash -lc '/opt/easy-rsa/generate-cert.sh $host_name'"
}

# ------------------------------------------------------------------------------
# Read value from a property file.
#
# Arguments
#    arg 1:  property file
#    arg 2:  key
#    return: the value of the key
# ------------------------------------------------------------------------------
get_value() {
  printf "%s" "$(grep -w "^$2" "$1" | cut -d'=' -f2)"
}

# ------------------------------------------------------------------------------
#  Import a certificate into an existing keystore.
#
#  Arguments
#    arg 1: alias name in the keystore
#    arg 2: certificate to be imported
#    arg 3: the keystore
#    arg 4: the keystore password
# ------------------------------------------------------------------------------
function import_to_keystore() {
  local alias certificate keystore storepass
  alias="$1"
  certificate="$2"
  keystore="$3"
  storepass="$4"

  printf "%s | [INFO ] importing \"%s\" certificate into \"%s\" keystore, alias: \"%s\", keystore-password: \"%s\"...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$certificate" "$keystore" "$alias" "$storepass"
  keytool \
    -importcert \
    -alias "$alias" \
    -file "$certificate" \
    -keystore "$keystore" \
    -storepass "$storepass" \
    -noprompt
}

# ------------------------------------------------------------------------------
#  Run an external bash script if it exists.
# ------------------------------------------------------------------------------
function script_runner() {
  local script_file
  script_file="$1"

  local start elapsed
  if [ -f "$script_file" ]; then
    start=$(date +%s)
    printf "%s | [DEBUG] -----------------------------------------------------------\n" "$(date +"%Y-%b-%d %H:%M:%S")"
    printf "%s | [INFO]  executing the \"%s\" script...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$script_file"
    printf "%s | [DEBUG] ===========================================================\n" "$(date +"%Y-%b-%d %H:%M:%S")"
    "$script_file"
    elapsed=$(($(date +%s) - start))
    printf "%s | [INFO]  end of the \"%s\" script\n" "$script_file" "$(date +"%Y-%b-%d %H:%M:%S")"
    printf "%s | [INFO]  execution time: %s\n" "$(date -d@$elapsed -u +%H\ hour\ %M\ day\ %S\ sec)" "$(date +"%Y-%b-%d %H:%M:%S")"
  else
    printf "%s | [WARN]  script \"%s\" not exist, ignoring it\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$script_file"
  fi
}

# ------------------------------------------------------------------------------
# Set the container state to "ready" by opening a port.
# This indicates that the container and all services in the container is up and
# ready to server incoming requests. Containers running in the same docker
# network can use this port to decide whether a container is up.
#
# This runs at the background in order to does not block the execution.
# ------------------------------------------------------------------------------
function set_container_up_state() {
  printf "%s | [INFO]  docker container is READY to serve incoming requests\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  printf "%s | [DEBUG] opening port %s...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$UP_SIGNAL_PORT"

  local marker_file
  marker_file="/tmp/first-startup.marker"
  touch "$marker_file"
  socat - tcp-listen:"$UP_SIGNAL_PORT",fork,reuseaddr &
}

# ------------------------------------------------------------------------------
#  This method is called when a SIGTERM signal appears.
# ------------------------------------------------------------------------------
function shutdown_trap() {
  printf "%s | [INFO]  shutting down the container...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  script_runner "/shutdown.sh"
}

# ------------------------------------------------------------------------------
# Checks whether this is the first startup of the container or not.
# ------------------------------------------------------------------------------
function is_first_startup() {
  local marker_file
  marker_file="/tmp/first-startup.marker"

  if [ -f "$marker_file" ]; then
    printf "false"
  else
    printf "true"
  fi
}

# ------------------------------------------------------------------------------
# Wait for the given container to be up and ready to serve requests.
#
# Arguments
#    arg 1: the container's hostname or IP address
# ------------------------------------------------------------------------------
wait_for_container() {
  local domain
  domain="$1"
  printf "%s | [INFO]  waiting for the \"%s\" container, port: \"%s\"...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$domain" "$UP_SIGNAL_PORT"
  while ! nc -w 5 -z "$domain" "$UP_SIGNAL_PORT" 2>/dev/null; do
    sleep 0.5
  done
  printf "%s | [INFO]  the \"%s\" container is up and running\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$domain"
}
