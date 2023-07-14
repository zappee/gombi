#!/bin/bash -ue
# ******************************************************************************
# This script blocks the execution and waits for external servers to be ready to
# serve incoming requests.
#
#  Since : July, 2023
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
source /shared.sh

# ------------------------------------------------------------------------------
#  Main program starts here.
# ------------------------------------------------------------------------------
printf "%s | [DEBUG] -----------------------------------------------------------\n" "$(date +"%Y-%b-%d %H:%M:%S")"
printf "%s | [DEBUG] executing the \"%s\" script...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$0"
printf "%s | [DEBUG] ===========================================================\n" "$(date +"%Y-%b-%d %H:%M:%S")"

wait_for_container "$CA_HOST"
