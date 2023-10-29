#!/bin/bash -ue
# ******************************************************************************
# HashiCorp Consule startup script.
#
# Since : Oct, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
. /shared.sh
. /consul-functions.sh

# ------------------------------------------------------------------------------
# Main program starts here.
# ------------------------------------------------------------------------------
log_start "$0"
start_consul
log_end "$0"
