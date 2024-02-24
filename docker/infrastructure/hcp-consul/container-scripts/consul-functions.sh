#!/bin/bash -ue
# ******************************************************************************
# Functions that helps to manage HashiCorp Consul.
#
# Since : October, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
. /shared.sh

# ----------------------------------------------------------------------------
# Configure the HashiCorp Consul.
# It generates the Consul configuration file.
# ------------------------------------------------------------------------------
function setup_consul() {
  local template_config_file config_file fqdn domain
  template_config_file="$CONSUL_CONFIG_TEMPLATE_DIR/consul-template.json"
  config_file="$CONSUL_CONFIG_DIR/consul.json"
  fqdn=$(hostname -f)
  domain=${fqdn#"${fqdn%.*.*}".}

  printf "%s | [INFO]  setting up HashiCorp Consul...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  printf "%s | [DEBUG]    config directory: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$CONSUL_CONFIG_DIR"
  printf "%s | [DEBUG]     config template: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$template_config_file"
  printf "%s | [DEBUG]         config file: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$config_file"
  printf "%s | [DEBUG]      data directory: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$CONSUL_DATA_DIR"
  printf "%s | [DEBUG]           node name: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$CONSUL_NODE_NAME"
  printf "%s | [DEBUG]       keystore home: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$KEYSTORE_HOME"
  printf "%s | [DEBUG]                fqdn: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$fqdn"
  printf "%s | [DEBUG]              domain: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$domain"

  mkdir -p "$CONSUL_CONFIG_DIR"
  cp -f "$template_config_file" "$config_file"
  sed -i "s|\${CONSUL_DATA_DIR}|$CONSUL_DATA_DIR|g" "$config_file"
  sed -i "s|\${CONSUL_NODE_NAME}|$CONSUL_NODE_NAME|g" "$config_file"
  sed -i "s|\${KEYSTORE_HOME}|$KEYSTORE_HOME|g" "$config_file"
  sed -i "s|\${FQDN}|$fqdn|g" "$config_file"
  sed -i "s|\${DOMAIN}|$domain|g" "$config_file"
}

# ----------------------------------------------------------------------------
# Start HashiCorp Consul.
# ------------------------------------------------------------------------------
function start_consul() {
  printf "%s | [INFO]  starting HashiCorp Consul...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  printf "%s | [DEBUG]    node name:        \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$CONSUL_NODE_NAME"
  printf "%s | [DEBUG]    config directory: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$CONSUL_CONFIG_DIR"
  printf "%s | [DEBUG]    data directory:   \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$CONSUL_DATA_DIR"

  consul agent \
    -server \
    -ui \
    -bootstrap \
    -bind=127.0.0.1 \
    -node="$CONSUL_NODE_NAME" \
    -config-dir="$CONSUL_CONFIG_DIR" \
    -data-dir="$CONSUL_DATA_DIR" &

  while [ "$(consul members 2>/dev/null | awk "/$CONSUL_NODE_NAME/ && /alive/" | wc -l)" -ne 1 ]; do
    printf "%s | [DEBUG] consul is not running, waiting...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
    sleep 0.5
  done

  printf "%s | [INFO]  HashiCorp Consul has been started\n" "$(date +"%Y-%b-%d %H:%M:%S")"
}
