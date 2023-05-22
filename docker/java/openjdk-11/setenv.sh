#!/bin/bash -ue
# ******************************************************************************
#  Environment file to define variables used during the Docker image build.
#
#  Since : January, 2023
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
IMAGE_NAME="openjdk-11"
IMAGE_TAG="0.0.1-remal"
IMAGE_DESCRIPTION="Remal OpenJDK 11 Docker image"
IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>"
IMAGE_FROM="base:0.0.1-remal"

BUILD_TYPE="${1:-fat}"
PUSH_IMAGE="${2:-false}"
