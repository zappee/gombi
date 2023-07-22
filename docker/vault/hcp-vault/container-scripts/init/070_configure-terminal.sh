#!/bin/bash -ue
# ******************************************************************************
# Bash environment configuration in Docker environment.
#
# Since : May, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
source /shared.sh
log_start "$0"
{
  printf "export %s=\"%s\"\n" "PKI_HOST" "$PKI_HOST"
  printf "export %s=\"%s\"\n" "AM_HOME" "$VAULT_HOME"
  printf "cd %s\n" "$VAULT_HOME"
} >> /etc/profile
log_end "$0"
