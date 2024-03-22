#!/bin/bash -ue
# ******************************************************************************
# Remal Docker container deployer file.
#
# Since : March 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
. setenv.sh
docker run \
  --name "$IMAGE_NAME.$DOMAIN_NAME" \
  --hostname "$IMAGE_NAME.$DOMAIN_NAME" \
  --detach \
  --publish 13022:22 \
  "$IMAGE_NAME":"$IMAGE_TAG"
