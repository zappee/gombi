#!/bin/bash -ue
# ******************************************************************************
# ForgeRock Directory Service Docker container deployer file.
#
# Since : January, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
source setenv.sh
docker run \
  --name "$IMAGE_NAME.remal.com" \
  --hostname "$IMAGE_NAME.remal.com" \
  --detach \
  --env CA_HOST=ca.hello.com \
  --env DS_HOST=ds.hello.com \
  --env CONFIG_BACKUP=true \
  --env CONFIG_RESTORE_FROM=forgerock-ds-conf-2023-05-22_12.24.57.tar.gz \
  --env LDAP_BACKUP=true \
  --env LDAP_RESTORE_FROM=forgerock-ds-ldap-2023-05-22_12.24.50.tar.gz \
  --publish 13022:22 \
  --publish 13036:636 \
  --publish 13044:4444 \
  --volume "$HOME/dev/workspace/java/remal/gombi/docker/forgerock/forgerock-ds/backup:/opt/opendj/backup" \
  "$IMAGE_NAME":"$IMAGE_TAG"
