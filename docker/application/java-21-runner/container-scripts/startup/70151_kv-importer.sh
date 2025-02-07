#!/bin/bash -ue
# ******************************************************************************
# The kv-importer script is used to import key/value pairs from a properties
# file. This script reads the *.properties file during the Docker container
# startup and adds the missing KV pairs into Hashicorp Consul.
#
# Since:  March 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
. /shared.sh

# ------------------------------------------------------------------------------
# Checks if the provided files exist or not.
# If the files doe not exist then it exits from the script.
#
# Arguments
#    arg 1:  path to the file that must exists
# ------------------------------------------------------------------------------
file_exists() {
  local file_to_check
  file_to_check="$1"

  if [ ! -f "$file_to_check" ]; then
    printf "%s | [WARN]  file \"%s\" not found\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$file_to_check"
    log_end "$0"
    exit 0
  else
    printf "%s | [DEBUG] file \"%s\" has been successfully extracted\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$file_to_check"
  fi
}

# ------------------------------------------------------------------------------
# Clean up the temporary files.
#
# Arguments:
#    arg 1:  the workspace directory

# ------------------------------------------------------------------------------
cleanup_workspace() {
  local workspace_home
  workspace_home="$1"

  printf "%s | [INFO]  cleaning up the workspace: \"%s\"...\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$workspace_home"
  rm -R "$workspace_home"
}

# ------------------------------------------------------------------------------
# Unpack the given file from the ZIP.
#
# Arguments:
#    arg 1:  source zip file
#    arg 2:  target directory to extract the file
#    arg 3:  the file to extract from the ZIP
# ------------------------------------------------------------------------------
extract_file() {
  local archive_file target_dir fie_to_extract
  archive_file="$1"
  target_dir="$2"
  fie_to_extract="$3"

  if [ -z "$archive_file" ]; then
    printf "%s | [WARN]  there is nothing to unpack\n" "$(date +"%Y-%m-%d %H:%M:%S")"
  else
    printf "%s | [DEBUG] unpacking the \"%s\" file from \"%s\" to \"%s\"...\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$fie_to_extract" "$archive_file" "$target_dir"

    # Ignore a specific exit code that appears if there file to extract not found in the ZIP.
    #
    # Exit codes (see the full list here: https://linux.die.net/man/1/unzip):
    #     9: the specified zipfiles were not found
    #    11: no matching files were found
    unzip -j "$archive_file" "$fie_to_extract" -d "$target_dir" || (exit "$(($? == 11 ? 0 : $?))")
  fi
}

# ------------------------------------------------------------------------------
# Get the key context for the Hashicorp Consul KV store.
# The property key in the Consul KV store should always start with “config” name
# followed by application main class name (spring.application.name). The main
# class name can be overwritten by the spring.cloud.consul.config.name setting.
#
# For example, if
#       - java code: @Value("${app.hello}")
#       - application.properties: spring.application.name=welcome-service
#    then the full path of the key is config/welcome-service/app.hello
#
# Arguments
#    arg 1: property file
#    arg 2: variable to hold the return value
# ------------------------------------------------------------------------------
get_kv_context() {
  local properties_file application_name config_name key_context
  properties_file="$1"
  application_name=$( (grep -w "^spring.application.name" | cut -d'=' -f2) < "$properties_file")
  config_name=$( (grep -w "^spring.cloud.consul.config.name" | cut -d'=' -f2) < "$properties_file")
  key_context="config/"

  if [[ -n "$config_name" ]]; then
    key_context+="$config_name"
  else
    key_context+="$application_name"
  fi

  local result
  result="$2"
  eval "$result"="${key_context}"
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

  printf "%s | [INFO]  getting the first JAR file from \"%s\" directory...\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$jars_home"

  local files number_of_files
  files=($(find "$jars_home" -type f -name "*.jar"))
  number_of_files=${#files[@]}
  printf "%s | [DEBUG] found %s file(s) in the \"%s\" directory\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$number_of_files" "$jars_home"

  if [[ "$number_of_files" -eq 0 ]]; then
    printf "%s | [WARN]  there is no *.jar files in the \"%s\" directory, exiting...\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$jars_home"
  elif [[ "$number_of_files" -gt 1 ]]; then
    printf "%s | [ERROR] ambiguous configuration, there are more then one JAR file to execute:\n" "$(date +"%Y-%m-%d %H:%M:%S")"
    printf "%s\n" "${files[@]}"
    exit 1
  fi

  local result
  result="$2"
  if [ ${#files[@]} -eq 0 ]; then
    # no files in the dir
    eval "$result"=""
  else
    # directory not empty
    eval "$result"="${files[0]}"
  fi
}

# ------------------------------------------------------------------------------
# Inserts the missing KV pairs into the Hashicorp Consul.
#
# Arguments
#    arg 1:  path to the *.properties file
#    arg 2:  the key context in the KV store
# ------------------------------------------------------------------------------
insert_kv() {
  local properties_file key_context
  properties_file="$1"
  key_context="$2"

  while IFS='=' read -d $'\n' -r key value; do
    [[ "$key" =~ ^([[:space:]]*|[[:space:]]*#.*)$ ]] && continue
      key="${key_context}/${key}"
      if consul kv get "$key" 2>/dev/null 1>/dev/null; then
        printf "%s | [DEBUG]  \"%s\" key exist, ignore it\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$key"
      else
        printf "%s | [DEBUG]  inserting \"%s\"=\"%s\"...\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$key" "$value"

        local base64_value
        base64_value=$(printf "%b%s" "$value" | base64)
        printf "%s | [DEBUG]  base64 encoded value: \"%s\"=\"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$value" "$base64_value"

        consul kv put -base64 "$key" "$base64_value" 1>/dev/null
      fi
  done < "$properties_file"
}

# ------------------------------------------------------------------------------
# Main program starts here.
# ------------------------------------------------------------------------------
log_start "$0"
printf "%s | [INFO]  inserting key/values into Hashicorp Consul...\n" "$(date +"%Y-%m-%d %H:%M:%S")"

UNPACK_DIR="/tmp/extracted-jar"
PATH_TO_PROP_FILE="BOOT-INF/classes"
APP_PROP_FILE="application.properties"
KV_PROP_FILE="config.properties"

get_first_jar "$JAR_HOME" JAR_FILE

extract_file "$JAR_FILE" "$UNPACK_DIR" "$PATH_TO_PROP_FILE/$APP_PROP_FILE"
file_exists "$UNPACK_DIR/$APP_PROP_FILE"

extract_file "$JAR_FILE" "$UNPACK_DIR" "$PATH_TO_PROP_FILE/$KV_PROP_FILE"
file_exists "$UNPACK_DIR/$KV_PROP_FILE"

get_kv_context "$UNPACK_DIR/$APP_PROP_FILE" CONTEXT
insert_kv "$UNPACK_DIR/$KV_PROP_FILE" "$CONTEXT"
cleanup_workspace "$UNPACK_DIR"

log_end "$0"
