#!/bin/bash -ue
# ******************************************************************************
# Configure the Hazelcast IMDG Cache.
#
# Since:  September 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
. /shared.sh
. /imdg-functions.sh

# ------------------------------------------------------------------------------
# Main program starts here.
# ------------------------------------------------------------------------------
log_start "$0"
setup_imdg
log_end "$0"
