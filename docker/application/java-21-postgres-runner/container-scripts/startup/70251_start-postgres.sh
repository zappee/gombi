#!/bin/bash -ue
# ******************************************************************************
# Postgres database server startup script.
#
# Since:  April 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
. /shared.sh

# ------------------------------------------------------------------------------
# Start the Postgres Database Server and wait for the full server start-up.
# ------------------------------------------------------------------------------
function start_postgres() {
  if [ "$START_POSTGRES" == "true" ]; then
    printf "%s | [INFO]  starting Postgres database server...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
    printf "%s | [DEBUG]     POSTGRES_DATA: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$POSTGRES_DATA"
    printf "%s | [DEBUG]    START_POSTGRES: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$START_POSTGRES"

    /bin/su -c "pg_ctl start -D $POSTGRES_DATA" - postgres
    # todo wait_until_text_found "$PROMETHEUS_LOG" "database system is ready to accept connections"

    printf "%s | [INFO]  Postgres Database server has been started...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  else
    printf "%s | [DEBUG] skip the startup of the Postgres database server...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  fi
}

# ------------------------------------------------------------------------------
# Main program starts here.
# ------------------------------------------------------------------------------
log_start "$0"
start_postgres
log_end "$0"
