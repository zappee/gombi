#!/bin/bash -ue
# ******************************************************************************
# Prometheus startup script.
#
# Since:  March 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
. /shared.sh

# ------------------------------------------------------------------------------
# Start the Grafana Server and wait for the full server start-up.
# ------------------------------------------------------------------------------
function start_grafana() {
  printf "%s | [INFO]  starting Grafana...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  printf "%s | [DEBUG]    GRAFANA_HOME: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$GRAFANA_HOME"

  cd "$GRAFANA_HOME"
  ./bin/grafana server 2>&1 &
  tail -F "$GRAFANA_LOG"/grafana.log &
  wait_until_text_found "$PROMETHEUS_LOG" "Adding GroupVersion featuretoggle.grafana.app"
  printf "%s | [INFO]  Grafana has been started...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
}

# ------------------------------------------------------------------------------
# Main program starts here.
# ------------------------------------------------------------------------------
log_start "$0"
start_grafana
log_end "$0"
