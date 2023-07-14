#!/bin/bash -ue
# ******************************************************************************
# Bash environment configuration in Docker environment.
#
# Since : May, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
printf "%s | [DEBUG] -----------------------------------------------------------\n" "$(date +"%Y-%b-%d %H:%M:%S")"
printf "%s | [DEBUG] executing the \"%s\" script...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$0"
printf "%s | [DEBUG] ===========================================================\n" "$(date +"%Y-%b-%d %H:%M:%S")"

{
  printf "export %s=\"%s\"\n" "LDAP_HOST" "$EXPOSED_HTTPS_PORT"
  printf "export %s=\"%s\"\n" "CA_HOST" "$CA_HOST"
  printf "export %s=\"%s\"\n" "CONFIG_TOOL_HOME" "$AM_CONFIG_TOOL_HOME"
  printf "export %s=\"%s\"\n" "AM_HOME" "$AM_HOME"
  printf "export %s=\"%s\"\n" "CATALINA_OPTS" "$CATALINA_OPTS"
} >> /etc/profile
