#!/bin/bash -ue
# ******************************************************************************
#  Remal Apache Tomcat 9 Docker container deployer file.
#
#  Since : January, 2023
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
source setenv.sh
docker run \
  --name "$IMAGE_NAME.remal.com" \
  --hostname "$IMAGE_NAME.remal.com" \
  --detach \
  --env BACKUP_CONFIG=true \
  --env BACKUP_CONFIG_FILE=backup-config-2023-03-10_15.11.28.tar.gz \
  --env BACKUP_LDAP=true \
  --env BACKUP_LDAP_FILE=backup-ldap-2023-03-10_15.11.28.tar.gz \
  --publish 13022:22 \
  --publish 13044:4444 \
  --publish 13036:636 \
  --volume "$HOME/dev/workspace/java/remal/gombi/docker/forgerock/forgerock-ds/backup:/opt/opendj/backup" \
  "$IMAGE_NAME":"$IMAGE_TAG"
