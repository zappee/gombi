#!/bin/bash -ue
# ******************************************************************************
# Functions that helps to manage Hazelcast IMDG.
#
# Since:  September 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
. /shared.sh

# ----------------------------------------------------------------------------
# Configure the Hazelcast IMDG.
# It generates the IMDG configuration file.
# ------------------------------------------------------------------------------
function setup_imdg() {
  local template_config_file config_file fqdn domain
  template_config_file="$HAZELCAST_CONFIG_TEMPLATE_DIR/hazelcast.xml"
  config_file="$HAZELCAST_HOME/bin/hazelcast.xml"
  fqdn=$(hostname -f)
  domain=${fqdn#"${fqdn%.*.*}".}

  local keystore_file keystore_password
  keystore_file="/tmp/$fqdn.p12"
  keystore_password="changeit"

  printf "%s | [INFO]  setting up Hazelcast IMDG...\n" "$(date +"%Y-%m-%d %H:%M:%S")"
  printf "%s | [DEBUG]          HAZELCAST_HOME: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$HAZELCAST_HOME"
  printf "%s | [DEBUG]    template_config_file: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$template_config_file"
  printf "%s | [DEBUG]             config_file: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$config_file"
  printf "%s | [DEBUG]                    fqdn: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$fqdn"
  printf "%s | [DEBUG]                  domain: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$domain"
  printf "%s | [DEBUG]                keystore: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$keystore_file"
  printf "%s | [DEBUG]       keystore password: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$keystore_password"

  cp -f "$template_config_file" "$config_file"
  sed -i "s|\${KEYSTORE_FILE}|$keystore_file|g" "$config_file"
  sed -i "s|\${KEYSTORE_PASSWORD}|$keystore_password|g" "$config_file"
}

# ----------------------------------------------------------------------------
# Start Hazelcast IMDG.
# ------------------------------------------------------------------------------
function start_imdg() {
  printf "%s | [INFO]  starting Hazelcast IMDG...\n" "$(date +"%Y-%m-%d %H:%M:%S")"
  printf "%s | [DEBUG]    HAZELCAST_HOME: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$HAZELCAST_HOME"

  "$HAZELCAST_HOME"/bin/start.sh &

  while [ "$("$HAZELCAST_HOME"/bin/healthcheck.sh 2>/dev/null | awk "/\"nodeState\":\"ACTIVE\"/" | wc -l)" -ne 1 ]; do
    printf "%s | [DEBUG] Hazelcast IMDG is not running, waiting...\n" "$(date +"%Y-%m-%d %H:%M:%S")"
    sleep 0.5
  done

  printf "%s | [INFO]  Hazelcast IMDG has been started\n" "$(date +"%Y-%m-%d %H:%M:%S")"
}
