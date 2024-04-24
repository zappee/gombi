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
. /postgres-functions.sh

# ------------------------------------------------------------------------------
# Main program starts here.
# ------------------------------------------------------------------------------
log_start "$0"

postgres_configuration
start_postgres "true"
set_database_password "$DB_ADMIN_USER" "$DB_ADMIN_PASSWORD"
create_database_and_user "$DB_APP_USER" "$DB_APP_PASSWORD"
stop_postgres

log_end "$0"
