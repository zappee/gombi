#!/bin/bash -ue
# ******************************************************************************
# Back up the ForgeRock Directory Server.
#
# Since : January, 2023
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
if [ "$LDAP_BACKUP" == "true" ]; then
  backup_ds_data "am-config";
  backup_ds_data "am-identity-store";
fi
if [ "$CONFIG_BACKUP" == "true" ]; then backup_ds_config true; fi
log_end "$0"
