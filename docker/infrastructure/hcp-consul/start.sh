#!/bin/bash -ue
# ******************************************************************************
# Hashicorp Consul Docker container deployer file.
#
# Since : January 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
. setenv.sh
docker run \
  --name "$IMAGE_NAME.$DOMAIN_NAME" \
  --hostname "$IMAGE_NAME.$DOMAIN_NAME" \
  --detach \
  --env PKI_HOST="pki.$DOMAIN_NAME" \
  --publish 13062:22 \
  "$IMAGE_NAME":"$IMAGE_TAG"
