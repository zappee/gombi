#!/bin/bash -ue
# ******************************************************************************
# Restore configuration of the ForgeRock Directory Server.
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
if [ -n "$LDAP_RESTORE_FROM" ]; then restart_ds_ldap; fi
log_end "$0"
