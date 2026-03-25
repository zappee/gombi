#!/bin/bash -ue
# ******************************************************************************
# Environment file to define variables used during the Docker image build.
#
# Since:  March 2026
# Author: Arnold SOMOGYI <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2026 Remal Software and Arnold SOMOGYI All rights reserved
# ******************************************************************************
export IMAGE_FROM="remal-consul:$1"
export IMAGE_NAME="remal-java-25-runner"
export IMAGE_AUTHOR="Arnold SOMOGYI <arnold.somogyi@gmail.com>"
export IMAGE_DESCRIPTION="Remal Java 25 Runner"
