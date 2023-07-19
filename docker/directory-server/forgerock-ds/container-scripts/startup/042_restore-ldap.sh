#!/bin/bash -ue
# ******************************************************************************
# Restore LDAP data.
#
# Since : May, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
source /shared.sh
source /ds-functions.sh

# ------------------------------------------------------------------------------
# Main program starts here.
# ------------------------------------------------------------------------------
log_start "$0"
if [ -n "$AM_IDENTITY_STORE_RESTORE_FROM" ]; then restore_ds_data "$AM_IDENTITY_STORE_RESTORE_FROM" "$AM_IDENTITY_STORE_NAME"; fi
log_end "$0"
