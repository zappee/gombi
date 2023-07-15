#!/bin/bash -ue
# ******************************************************************************
# Back up the ForgeRock Directory Server.
#
# Since : January, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
source /ds-functions.sh

# ------------------------------------------------------------------------------
# Main program starts here.
# ------------------------------------------------------------------------------
if [ "$LDAP_BACKUP" == "true" ]; then backup_ds_ldap; fi
if [ "$CONFIG_BACKUP" == "true" ]; then backup_ds_config true; fi
