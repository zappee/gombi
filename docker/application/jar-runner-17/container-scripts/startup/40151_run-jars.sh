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

number_of_jars=$(find "$JAR_HOME" -maxdepth 1 -type f -name "*.jar" | wc -l)
printf "%s | [DEBUG] JAR files in the %s directory: %s\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$JAR_HOME" "$number_of_jars"

if [[ "$number_of_jars" -eq 0 ]]; then
  printf "%s | [INFO]  there is no JAR file to execute\n" "$(date +"%Y-%b-%d %H:%M:%S")"
else
  cd "$JAR_HOME" || { echo "Error while trying to change directory from $(pwd) to $JAR_HOME"; exit 1; }

  for jar_file in "$JAR_HOME"/*.jar; do
    printf "%s | [INFO]  starting %s at the background...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$jar_file"
    nohup java -jar "$jar_file" 2>&1 &
    exit_code=$?
    pid=$!
    printf "%s | [DEBUG] PID       of the %s is %s\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$jar_file" "$pid"
    printf "%s | [DEBUG] Exit code of the %s is %s\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$jar_file" "$exit_code"

    timeout 5 tail --pid=$pid -f /dev/null
    exit_code=$?
    printf "%s | [DEBUG] Exit code of the %s is %s\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$jar_file" "$exit_code"
    if [ "$exit_code" -ne 0 ]; then
       printf "%s | [ERROR] Java application %s exited with an error: %s" "$(date +"%Y-%b-%d %H:%M:%S")" "$jar_file" "$exit_code"
    fi
  done
fi

log_end "$0"
