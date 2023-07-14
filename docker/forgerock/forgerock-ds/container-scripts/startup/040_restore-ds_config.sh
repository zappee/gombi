#!/bin/bash -ue
# ******************************************************************************
# Restore LDAP database of the ForgeRock Directory Server.
#
# Since : May, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
source /ds-functions.sh

# ------------------------------------------------------------------------------
# Main program starts here.
# ------------------------------------------------------------------------------
printf "%s | [DEBUG] -----------------------------------------------------------\n" "$(date +"%Y-%b-%d %H:%M:%S")"
printf "%s | [DEBUG] executing the \"%s\" script...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$0"
printf "%s | [DEBUG] ===========================================================\n" "$(date +"%Y-%b-%d %H:%M:%S")"
if [ -n "$CONFIG_RESTORE_FROM" ]; then restore_ds_config; fi
