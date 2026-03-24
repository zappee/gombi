#!/bin/bash -ue
# ******************************************************************************
# HashiCorp Consul startup script.
#
# Since:  October 2023
# Author: Arnold SOMOGYI <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2026 Remal Software and Arnold SOMOGYI All rights reserved
# ******************************************************************************
. /shared.sh
. /consul-functions.sh

# ------------------------------------------------------------------------------
# Main program starts here.
# ------------------------------------------------------------------------------
log_start "$0"
start_consul
log_end "$0"
