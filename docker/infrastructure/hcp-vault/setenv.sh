#!/bin/bash -ue
# ******************************************************************************
# Environment file to define variables used during the Docker image build.
#
# Since:  July 2023
# Author: Arnold SOMOGYI <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2026 Remal Software and Arnold SOMOGYI All rights reserved
# ******************************************************************************
export IMAGE_FROM="remal-base:$1"
export IMAGE_NAME="remal-vault"
export IMAGE_AUTHOR="Arnold SOMOGYI <arnold.somogyi@gmail.com>"
export IMAGE_DESCRIPTION="HashiCorp Vault"
