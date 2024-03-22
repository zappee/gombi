#!/bin/bash -ue
# ******************************************************************************
# Remal Docker container deployer file.
#
# Since : May 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
. setenv.sh
docker run \
  --name "$IMAGE_NAME.$DOMAIN_NAME" \
  --hostname "$IMAGE_NAME.$DOMAIN_NAME" \
  --detach \
  --publish 13022:22 \
  "$IMAGE_NAME":"$IMAGE_TAG"
