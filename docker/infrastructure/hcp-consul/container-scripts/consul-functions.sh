#!/bin/bash -ue
# ******************************************************************************
# Functions that helps to manage HashiCorp Consul.
#
# Since : October, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
. /shared.sh

# ----------------------------------------------------------------------------
# Start HashiCorp Consul.
# ------------------------------------------------------------------------------
function start_consul() {
  local node_name data_dir
  node_name="$CONSUL_NODE_NAME"
  data_dir="/tmp/consul"

  printf "%s | [INFO]  starting HashiCorp Consul...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  printf "%s | [DEBUG]    data directory: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$data_dir"
  printf "%s | [DEBUG]    node name:       \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$node_name"

  consul agent -server -bootstrap -bind=127.0.0.1 -data-dir "$data_dir" -node="$node_name" -ui -client=0.0.0.0 &

  while [ "$(consul members 2>/dev/null | awk "/$node_name/ && /alive/" | wc -l)" -ne 1 ]; do
    sleep 0.5
  done

  printf "%s | [INFO]  HashiCorp Consul has been started\n" "$(date +"%Y-%b-%d %H:%M:%S")"
}
