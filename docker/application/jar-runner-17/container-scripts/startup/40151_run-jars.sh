#!/bin/bash -ue
# ******************************************************************************
# Java JAR file runner.
#
# Since : February, 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
. /shared.sh

# ------------------------------------------------------------------------------
# Main program starts here.
# ------------------------------------------------------------------------------
log_start "$0"

FQDN=$(hostname -f)
export FQDN

number_of_jars=$(find "$JAR_HOME" -maxdepth 1 -type f -name "*.jar" | wc -l)
printf "%s | [DEBUG] JAR files in the %s directory: %s\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$JAR_HOME" "$number_of_jars"

if [[ "$number_of_jars" -eq 0 ]]; then
  printf "%s | [DEBUG] here is no JAR file to execute\n" "$(date +"%Y-%b-%d %H:%M:%S")"
else
  cd "$JAR_HOME" || { echo "Error while trying to change directory from $(pwd) to $JAR_HOME"; exit 1; }

  for jar_file in "$JAR_HOME"/*.jar; do
    printf "%s | [INFO]  starting %s at the background...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$jar_file"
    java -jar "$jar_file" 2>&1 &
    pid=$!
    timeout 5 bash -c 'while true; do if kill -0 '"$pid"' 2>/dev/null; then echo '"$(date +"%Y-%b-%d %H:%M:%S") \| [DEBUG] $jar_file started successfully"'; break; fi; sleep 0.5; done' || printf "%s | [ERROR] an unexpected error has occurred while starting %s\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$jar_file"
  done
fi

log_end "$0"
