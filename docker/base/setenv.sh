#!/bin/bash -ue
# ******************************************************************************
# Environment file to define variables used during the Docker image build.
#
# Since : May, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
IMAGE_NAME="base"
IMAGE_TAG="0.0.1-remal"
IMAGE_DESCRIPTION="Remal Base Docker image"
IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>"
IMAGE_FROM="alpine:3.17.3"

BUILD_TYPE="${1:-fat}"
PUSH_IMAGE="${2:-false}"
