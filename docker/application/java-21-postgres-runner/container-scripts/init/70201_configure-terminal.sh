#!/bin/bash -ue
# ******************************************************************************
# Bash environment configuration in Docker environment.
#
# Since:  March 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
. /shared.sh

log_start "$0"

{
  printf "export %s=\"%s\"\n" "POSTGRES_HOME" "$POSTGRES_HOME"
  printf "export %s=\"%s\"\n" "POSTGRES_DATA" "$POSTGRES_DATA"
} >> /etc/profile

log_end "$0"
