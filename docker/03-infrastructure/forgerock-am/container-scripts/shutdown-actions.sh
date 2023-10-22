#!/bin/bash -ue
# ******************************************************************************
# Back up the ForgeRock Access Management Server configuration files.
#
# Since : July, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
. /shared.sh

# ------------------------------------------------------------------------------
# Backup the ForgeRock Access Management Server configuration files.
# ------------------------------------------------------------------------------
function backup_am_config() {
  local timestamp backup_file
  timestamp="$(date "+%Y-%m-%d_%H.%M.%S")"
  backup_file="$AM_HOME/backup/am-config-files_$timestamp.tar.gz"

  printf "%s | [INFO]  backing up ForgeRock Access Management Server configuration...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  tar \
    -C "$(dirname "$AM_HOME")" \
    --exclude backup \
    --exclude var/debug \
    --exclude var/audit \
    --exclude var/stats* \
    -zcvf "$backup_file" "$(basename "$AM_HOME")"

  printf "%s | [DEBUG] server configuration backup file: %s\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$backup_file"
  printf "%s | [INFO]  configuration files has been backed up\n" "$(date +"%Y-%b-%d %H:%M:%S")"
}

# ------------------------------------------------------------------------------
# Stop Apache Tomcat server.
# ------------------------------------------------------------------------------
function stop_tomcat() {
  printf "%s | [INFO]  stopping Apache Tomcat...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  "$CATALINA_HOME/bin/catalina.sh" stop 15
  tail -F "$CATALINA_HOME/logs/catalina.out" & ( tail -f -n0 "$CATALINA_HOME/logs/catalina.out" & ) | grep -q "Destroying ProtocolHandler"
  printf "%s | [INFO]  Apache Tomcat has been stopped\n" "$(date +"%Y-%b-%d %H:%M:%S")"
}

# ------------------------------------------------------------------------------
# Main program starts here.
# ------------------------------------------------------------------------------
log_start "$0"
if [ "$AM_CONFIG_BACKUP" == "true" ]; then
  stop_tomcat
  backup_am_config
fi
log_end "$0"
