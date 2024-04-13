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
# Grafana server configuration.
# ------------------------------------------------------------------------------
function configure_grafana() {
  printf "%s | [INFO]  configuring Grafana...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  printf "%s | [DEBUG]             GRAFANA_HOME: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$GRAFANA_HOME"
  printf "%s | [DEBUG]           GRAFANA_CONFIG: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$GRAFANA_CONFIG"
  printf "%s | [DEBUG]          GRAFANA_STORAGE: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$GRAFANA_STORAGE"
  printf "%s | [DEBUG]          GRAFANA_LOG_DIR: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$GRAFANA_LOG_DIR"
  printf "%s | [DEBUG]          GRAFANA_PLUGINS: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$GRAFANA_PLUGINS"
  printf "%s | [DEBUG]     GRAFANA_PROVISIONING: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$GRAFANA_PROVISIONING"

  sed -i "s|\${GRAFANA_STORAGE}|$GRAFANA_STORAGE|g" "$GRAFANA_CONFIG"
  sed -i "s|\${GRAFANA_LOG_DIR}|$GRAFANA_LOG_DIR|g" "$GRAFANA_CONFIG"
  sed -i "s|\${GRAFANA_PLUGINS}|$GRAFANA_PLUGINS|g" "$GRAFANA_CONFIG"
  sed -i "s|\${GRAFANA_PROVISIONING}|$GRAFANA_PROVISIONING|g" "$GRAFANA_CONFIG"
}

# ----------------------------------------------------------------------------
# Set Grafana admin password.
# ------------------------------------------------------------------------------
function set_grafana_admin_password() {
  printf "%s | [INFO]  setting up Grafana password for the 'admin' user...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  printf "%s | [DEBUG]              GRAFANA_HOME: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$GRAFANA_HOME"
  printf "%s | [DEBUG]    GRAFANA_ADMIN_PASSWORD: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$GRAFANA_ADMIN_PASSWORD"
  cd "$GRAFANA_HOME"
  ./bin/grafana cli admin reset-admin-password "$GRAFANA_ADMIN_PASSWORD"
}

# ------------------------------------------------------------------------------
# Main program starts here.
# ------------------------------------------------------------------------------
log_start "$0"
configure_grafana
set_grafana_admin_password
log_end "$0"
