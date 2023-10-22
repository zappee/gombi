#!/bin/bash -ue
# ******************************************************************************
# Functions that helps to manage Apache Tomcat Server.
#
# Since : July, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************

# ------------------------------------------------------------------------------
# Start the Apache Tomcat Server and wait for the full server start-up and for
# the deployment of the applications. 
# ------------------------------------------------------------------------------
function start_tomcat() {
  printf "%s | [INFO]  starting Apache Tomcat...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  printf "%s | [DEBUG] CATALINA_OPTS=\"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$CATALINA_OPTS"
  printf "%s | [DEBUG] JAVA_OPTS=\"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$JAVA_OPTS"

  printf "JAVA_OPTS=\"%s\"" "$JAVA_OPTIONS" > "$CATALINA_HOME/bin/setenv.sh"
  chmod +x "$CATALINA_HOME/bin/setenv.sh"
  "$CATALINA_HOME/bin/catalina.sh" start
  tail -F "$CATALINA_HOME/logs/catalina.out" & ( tail -f -n0 "$CATALINA_HOME/logs/catalina.out" & ) | grep -q "Server startup in"
  printf "%s | [INFO]  Apache Tomcat has been started...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
}

# ------------------------------------------------------------------------------
# Stop the Apache Tomcat Server and wait until the server stops completely.
# ------------------------------------------------------------------------------
function stop_tomcat() {
  printf "%s | [INFO]  stopping Apache Tomcat...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  "$CATALINA_HOME/bin/catalina.sh" stop 15
  tail -F "$CATALINA_HOME/logs/catalina.out" & ( tail -f -n0 "$CATALINA_HOME/logs/catalina.out" & ) | grep -q "Destroying ProtocolHandler"
  printf "%s | [INFO]  Apache Tomcat has been stopped\n" "$(date +"%Y-%b-%d %H:%M:%S")"
}
