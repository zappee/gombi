#!/bin/bash -ue
# ******************************************************************************
# Start Apache Tomcat script.
#
# Since : May, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
source /shared.sh
log_start "$0"

# start tomcat
printf "JAVA_OPTS=\"%s\"" "$JAVA_OPTIONS" > "$CATALINA_HOME/bin/setenv.sh"; \
chmod +x "$CATALINA_HOME/bin/setenv.sh"
"$CATALINA_HOME/bin/catalina.sh" start

# pipe out the log to docker and wait for tomcat startup
tail -F "$CATALINA_HOME/logs/catalina.out" & ( tail -f -n0 "$CATALINA_HOME/logs/catalina.out" & ) | grep -q "Server startup in"
log_end "$0"
