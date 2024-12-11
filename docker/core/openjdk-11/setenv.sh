#!/bin/bash -ue
# ******************************************************************************
# Environment file to define variables used during the Docker image build.
#
# Since : January, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
export IMAGE_NAME="remal-openjdk-11"
export IMAGE_TAG="0.0.2"
export IMAGE_DESCRIPTION="OpenJDK 11 Docker image"
export IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>"
export IMAGE_FROM="remal-base:0.0.3"
export BUILD_TYPE="${1:-fat}"
export PUSH_IMAGE="${2:-false}"
export DOMAIN_NAME=${3:-hello.com}
