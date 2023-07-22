#!/bin/bash -ue
# ******************************************************************************
# ForgeRock Directory Service Docker container deployer file.
#
# Since : January, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
source ./setenv.sh
docker run \
  --name "$IMAGE_NAME.remal.com" \
  --hostname "$IMAGE_NAME.remal.com" \
  --detach \
  --env PKI_HOST=pki.hello.com \
  --publish 13042:22 \
  "$IMAGE_NAME":"$IMAGE_TAG"
