#!/bin/bash -ue
# ******************************************************************************
# Environment file to define variables used during the Docker image build.
#
# Since : January, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
export IMAGE_NAME="remal-openjdk-17"
export IMAGE_TAG="0.0.1"
export IMAGE_DESCRIPTION="OpenJDK 17 Docker image"
export IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>"
export IMAGE_FROM="remal-base:0.0.1"
export BUILD_TYPE="${1:-fat}"
export PUSH_IMAGE="${2:-false}"
export DOMAIN_NAME=${3:-hello.com}
