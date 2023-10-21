#!/bin/bash -ue
# ******************************************************************************
# Environment file to define variables used during the Docker image build.
#
# Since : January, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
IMAGE_NAME="am-7.3"
IMAGE_TAG="0.0.1-remal"
IMAGE_DESCRIPTION="ForgeRock Directory Server 7.3.0"
IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>"
IMAGE_FROM="tomcat-9:0.0.1-remal"
DOMAIN_NAME="hello.com"

BUILD_TYPE=${1:-fat}
PUSH_IMAGE=${2:-false}
