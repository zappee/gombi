#!/bin/bash -ue
# ******************************************************************************
# The kv-importer script is used to import key/value pairs from a properties
# file. This script reads the *.properties file during the Docker container
# startup and adds the missing KV pairs into Hashicorp Consul.
#
# Since : March 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
. /shared.sh

# ------------------------------------------------------------------------------
# Clean up the temporary files.
#
# Arguments:
#    arg 1:  the workspace directory

# ------------------------------------------------------------------------------
cleanup_workspace() {
  local workspace_home
  workspace_home="$1"

  printf "%s | [INFO]  cleaning up the workspace: \"%s\"...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$workspace_home"
  rm -R "$workspace_home"
}

# ------------------------------------------------------------------------------
# Get the first JAR file from the given directory.
#
# Arguments:
#    arg 1:  the directory
#    return: the firs *.jar file from the directory
# ------------------------------------------------------------------------------
get_first_jar() {
  local jars_home
  jars_home="$1"

  printf "%s | [INFO]  getting the first JAR file from the \"%s\" directory...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$jars_home"

  local files
  files=($jars_home/*.jar)
  if (( ${#files[@]} == 0 )); then
    printf "%s | [ERROR] there is no *.jar files in the \"%s\" directory\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$jars_home"
    exit 1
  fi

  local result
  result="$2"
  eval "$result"="${files[1]}"
}

# ------------------------------------------------------------------------------
# Inserts the missing KV pairs into the Hashicorp Consul.
#
# Arguments
#    arg 1:  path to the *.properties file
# ------------------------------------------------------------------------------
insert_kv() {
  local properties_file
  properties_file="$1"

  while IFS='=' read -d $'\n' -r key value; do
    [[ "$key" =~ ^([[:space:]]*|[[:space:]]*#.*)$ ]] && continue
      key=${key//.//}   # replacing all the "." characters to "/"
      if consul kv get "$key" 2>/dev/null 1>/dev/null; then
        printf "%s | [DEBUG]  \"%s\" key exist, ignore it\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$key"
      else
        printf "%s | [DEBUG]  inserting \"%s\"=\"%s\"...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$key" "$value"
        consul kv put "$key" "$value" 1>/dev/null
      fi
  done < "$properties_file"
}

# ------------------------------------------------------------------------------
# Checks the provided file exists or not.
# If the file not exist it exits the script.
#
# Arguments
#    arg 1:  path to the file
# ------------------------------------------------------------------------------
validate_file() {
  local file_to_check
  file_to_check="$1"

  if [ ! -f "$file_to_check" ]; then
    printf "%s | [ERROR] file \"%s\" not found\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$file_to_check"
    exit 0
  fi
}

# ------------------------------------------------------------------------------
# Unpack the given ZIP archive file.
#
# Arguments:
#    arg 1:  zip file to extract
#    arg 2:  target directory to extract the file
# ------------------------------------------------------------------------------
unpack_jar() {
  local archive_file target
  archive_file="$1"
  target="$2"

  printf "%s | [INFO]  extracting the \"%s\" file to \"%s\"...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$archive_file" "$target"
  unzip "$archive_file" -d "$target"
}

# ------------------------------------------------------------------------------
# Main program starts here.
# ------------------------------------------------------------------------------
log_start "$0"

UNPACK_DIR="/tmp/extracted-jar"
PROP_FILE="$UNPACK_DIR/BOOT-INF/classes/config.properties"
printf "%s | [INFO]  inserting key/values into Hashicorp Consul...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
get_first_jar "$JAR_HOME" JAR_FILE
printf "%s | [DEBUG] extracting the \"%s\" file from the \"%s\"...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$PROP_FILE" "$JAR_FILE"
unpack_jar "$JAR_FILE" "$UNPACK_DIR"
validate_file "$PROP_FILE"
insert_kv "$PROP_FILE"
cleanup_workspace "$UNPACK_DIR"

log_end "$0"
