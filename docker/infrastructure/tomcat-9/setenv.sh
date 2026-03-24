#!/bin/bash -ue
# ******************************************************************************
# Environment file to define variables used during the Docker image build.
#
# Since:  January 2023
# Author: Arnold SOMOGYI <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2026 Remal Software and Arnold SOMOGYI All rights reserved
# ******************************************************************************
export IMAGE_FROM="remal-openjdk-11:$1"
export IMAGE_NAME="remal-tomcat-9"
export IMAGE_AUTHOR="Arnold SOMOGYI <arnold.somogyi@gmail.com>"
export IMAGE_DESCRIPTION="Apache Tomcat 9 Docker image"
