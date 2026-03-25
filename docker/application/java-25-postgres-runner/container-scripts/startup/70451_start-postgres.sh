#!/bin/bash -ue
# ******************************************************************************
# Postgres database server startup script.
#
# Since:  March 2026
# Author: Arnold SOMOGYI <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2026 Remal Software and Arnold SOMOGYI All rights reserved
# ******************************************************************************
. /shared.sh
. /postgres-functions.sh

# ------------------------------------------------------------------------------
# Main program starts here.
# ------------------------------------------------------------------------------
log_start "$0"
start_postgres "$START_DB"
log_end "$0"
