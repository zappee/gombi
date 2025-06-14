#!/bin/bash -ue
# ******************************************************************************
# Environment file to define variables used during the Docker image build.
#
# Since:  April 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
export IMAGE_FROM="remal-base:$1"
export IMAGE_NAME="remal-grafana"
export IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>"
export IMAGE_DESCRIPTION="Remal Grafana"
