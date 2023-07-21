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
  --env DS_CONFIG_BACKUP=true \
  --env DS_CONFIG_RESTORE_FROM=latest \
  --env AM_IDENTITY_STORE_BACKUP=true \
  --env AM_IDENTITY_STORE_RESTORE_FROM=latest \
  --env AM_CONFIG_STORE_BACKUP=true \
  --env AM_CONFIG_STORE_RESTORE_FROM=latest \
  --publish 13022:22 \
  --publish 13036:636 \
  --publish 13044:4444 \
  --volume "$HOME/dev/workspace/java/remal/gombi/backups/containers:/opt/opendj/backup" \
  "$IMAGE_NAME":"$IMAGE_TAG"
