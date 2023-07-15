#!/bin/bash -ue
# ******************************************************************************
# Stop Apache Tomcat script.
#
# Since : Jul, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
printf "%s | [DEBUG] -----------------------------------------------------------\n" "$(date +"%Y-%b-%d %H:%M:%S")"
printf "%s | [DEBUG] executing the \"%s\" script...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$0"
printf "%s | [DEBUG] ===========================================================\n" "$(date +"%Y-%b-%d %H:%M:%S")"
printf "%s | [INFO]  stopping Apache Tomcat...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
"$CATALINA_HOME/bin/catalina.sh" stop 15
