#!/bin/bash -ue
# ******************************************************************************
# Bash environment configuration in Docker environment.
#
# Since : March 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
. /shared.sh
log_start "$0"
{
  printf "export %s=\"%s\"\n" "JAR_HOME" "$JAR_HOME"
  printf "cd %s\n" "$JAR_HOME"
} >> /etc/profile
log_end "$0"
