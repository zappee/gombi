#!/bin/bash -ue
# ******************************************************************************
# Stop Apache Tomcat script.
#
# Since : Jul, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
source /shared.sh
log_start "$0"
printf "%s | [INFO]  stopping Apache Tomcat...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
"$CATALINA_HOME/bin/catalina.sh" stop 15
log_end "$0"
