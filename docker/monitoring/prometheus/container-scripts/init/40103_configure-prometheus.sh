#!/bin/bash -ue
# ******************************************************************************
# Prometheus configuration.
#
# Since:  April 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
. /shared.sh

# ----------------------------------------------------------------------------
# Prometheus SSL configuration.
# ------------------------------------------------------------------------------
function configure_ssl() {
  local fqdn
  fqdn=$(hostname -f)

  printf "%s | [INFO]  configuring Prometheus to use SSL (HTTPS) for the web console...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  printf "%s | [DEBUG]                     FQDN: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$fqdn"
  printf "%s | [DEBUG]            KEYSTORE_HOME: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$KEYSTORE_HOME"
  printf "%s | [DEBUG]    PROMETHEUS_WEB_CONFIG: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$PROMETHEUS_WEB_CONFIG"

  sed -i "s|\${KEYSTORE_HOME}|$KEYSTORE_HOME|g" "$PROMETHEUS_WEB_CONFIG"
  sed -i "s|\${FQDN}|$fqdn|g" "$PROMETHEUS_WEB_CONFIG"
}

# ------------------------------------------------------------------------------
# Main program starts here.
# ------------------------------------------------------------------------------
log_start "$0"
configure_ssl
log_end "$0"
