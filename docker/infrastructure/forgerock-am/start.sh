#!/bin/bash -ue
# ******************************************************************************
# ForgeRock Access Management Docker container deployer file.
#
# Since : January, 2023
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
  --env DS_HOST="ds.$DOMAIN_NAME" \
  --env DS_PORT=636 \
  --env DS_USER_DN=uid=admin \
  --env DS_USER_PASSWORD=password \
  --env AM_PORT=password \
  --env BACKUP_CONFIG true \
  --env BACKUP_CONFIG_FILE=forgerock-am-conf-2023-05-22_12.24.57.tar.gz \
  --publish 13012:22 \
  --publish 13018:8080 \
  --publish 13014:443 \
  --volume "$HOME/dev/workspace/java/remal/gombi/docker/forgerock/forgerock-am/backup:/home/openam/backup" \
  "$IMAGE_NAME":"$IMAGE_TAG"
