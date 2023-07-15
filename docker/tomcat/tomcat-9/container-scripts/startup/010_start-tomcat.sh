#!/bin/bash -ue
# ******************************************************************************
# Start Apache Tomcat script.
#
# Since : May, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
printf "%s | [DEBUG] -----------------------------------------------------------\n" "$(date +"%Y-%b-%d %H:%M:%S")"
printf "%s | [DEBUG] executing the \"%s\" script...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$0"
printf "%s | [DEBUG] ===========================================================\n" "$(date +"%Y-%b-%d %H:%M:%S")"
printf "%s | [INFO]  starting Apache Tomcat...\n" "$(date +"%Y-%b-%d %H:%M:%S")"

# start tomcat
printf "JAVA_OPTS=\"%s\"" "$JAVA_OPTIONS" > "$CATALINA_HOME/bin/setenv.sh"
chmod +x "$CATALINA_HOME/bin/setenv.sh"
"$CATALINA_HOME/bin/catalina.sh" start

# pipe out the log to docker and wait for tomcat startup
tail -F "$CATALINA_HOME/logs/catalina.out" & ( tail -f -n0 "$CATALINA_HOME/logs/catalina.out" & ) | grep -q "Server startup in"
