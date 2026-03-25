#!/bin/bash -ue
# ******************************************************************************
# Start Apache Tomcat script.
#
# Since:  May 2023
# Author: Arnold SOMOGYI <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2026 Remal Software and Arnold SOMOGYI All rights reserved
# ******************************************************************************
. /shared.sh
. /tomcat-functions.sh

log_start "$0"
start_tomcat
log_end "$0"
