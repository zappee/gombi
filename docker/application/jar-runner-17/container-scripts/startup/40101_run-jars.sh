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

number_of_jars=$(find "$JAR_HOME" -maxdepth 1 -type f -name "*.jar" -printf x | wc -c)
if [[ "$number_of_jars" -eq 0 ]]; then
  printf "%s | [INFO]  there is no JAR file to execute\n" "$(date +"%Y-%b-%d %H:%M:%S")"
else
  cd "$JAR_HOME" || { echo "Error while trying to change directory from $(pwd) to $JAR_HOME"; exit 1; }
  for jar_file in "$JAR_HOME"/*.jar; do
    printf "%s | [INFO]  running %s at the background...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$JAR_HOME/$jar_file"
    java -jar "$JAR_HOME/$jar_file" &
  done
fi

log_end "$0"
