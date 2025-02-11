#!/bin/bash -ue
# ******************************************************************************
# Functions that helps to manage Hazelcast Platform.
#
# Since:  February 2025
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
. /shared.sh

# ----------------------------------------------------------------------------
# Configure the Hazelcast Platform.
# It produces the Platform's configuration files.
# ------------------------------------------------------------------------------
function setup_hazelcast() {
  local template_hazelcast_config
  template_hazelcast_config="hazelcast.xml"

  local fqdn keystore_file keystore_password
  fqdn=$(hostname -f)
  keystore_file="/tmp/$fqdn.p12"
  keystore_password="changeit"

  printf "%s | [INFO]  setting up Hazelcast Platform...\n" "$(date +"%Y-%m-%d %H:%M:%S")"
  printf "%s | [DEBUG]                      HAZELCAST_HOME: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$HAZELCAST_HOME"
  printf "%s | [DEBUG]       HAZELCAST_CONFIG_TEMPLATE_DIR: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$HAZELCAST_CONFIG_TEMPLATE_DIR"
  printf "%s | [DEBUG]           template_hazelcast_config: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$template_hazelcast_config"
  printf "%s | [DEBUG]                                fqdn: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$fqdn"
  printf "%s | [DEBUG]                            keystore: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$keystore_file"
  printf "%s | [DEBUG]                   keystore password: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$keystore_password"

  cp -f "$HAZELCAST_CONFIG_TEMPLATE_DIR/$template_hazelcast_config" "$HAZELCAST_HOME/config/"
  sed -i "s|\${HAZELCAST_CLUSTER_NAME}|$HAZELCAST_CLUSTER_NAME|g" "$HAZELCAST_HOME/config/$template_hazelcast_config"
  sed -i "s|\${KEYSTORE_FILE}|$keystore_file|g" "$HAZELCAST_HOME/config/$template_hazelcast_config"
  sed -i "s|\${KEYSTORE_PASSWORD}|$keystore_password|g" "$HAZELCAST_HOME/config/$template_hazelcast_config"
}

# ----------------------------------------------------------------------------
# Start Hazelcast Platform.
# ------------------------------------------------------------------------------
function start_hazelcast() {
  printf "%s | [INFO]  starting Hazelcast Platform...\n" "$(date +"%Y-%m-%d %H:%M:%S")"
  printf "%s | [DEBUG]    HAZELCAST_HOME: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$HAZELCAST_HOME"

  "$HAZELCAST_HOME"/bin/hz start &
  wait_until_content_found "$HAZELCAST_HOME/logs/hazelcast.log" "is STARTED"
}
