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
# Postgres server configuration.
# ------------------------------------------------------------------------------
function postgres_configuration() {
  printf "%s | [INFO]  configuring Postgres database server...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  printf "%s | [DEBUG]     POSTGRES_CONFIG: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$POSTGRES_CONFIG"
  printf "%s | [DEBUG]    POSTGRES_LOG_DIR: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$POSTGRES_LOG_DIR"

  sed -i "s|\${POSTGRES_LOG_DIR}|$POSTGRES_LOG_DIR|g" "$POSTGRES_CONFIG"
}

# ------------------------------------------------------------------------------
# Main program starts here.
# ------------------------------------------------------------------------------
log_start "$0"
postgres_configuration
log_end "$0"
