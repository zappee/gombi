#!/bin/bash -ue
# ******************************************************************************
# Environment file to define variables used during the Docker image build.
#
# Since : May, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
export IMAGE_NAME="remal-base"
export IMAGE_DESCRIPTION="Remal Base Docker image"
export IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>"
export IMAGE_FROM="alpine:3.21.2"
export BUILD_TYPE="${1:-fat}"
export PUSH_IMAGE="${2:-false}"
export DOMAIN_NAME=${3:-hello.com}
