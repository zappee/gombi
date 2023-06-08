#!/bin/sh -ue
# ******************************************************************************
#  ForgeRock Access Management Docker container deployer file.
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
  --env BACKUP_CONFIG true \
  --env BACKUP_CONFIG_FILE=forgerock-am-conf-2023-05-22_12.24.57.tar.gz \
  --env CA_HOST=ca.hello.com \
  --env LDAP_HOST=ds.remal.com \
  --env LDAP_PORT=636 \
  --env LDAP_USER_DN=uid=admin \
  --env LDAP_USER_PASSWORD=password \
  --publish 13012:22 \
  --publish 13018:8080 \
  --publish 13014:443 \
  --volume "$HOME/dev/workspace/java/remal/gombi/docker/forgerock/forgerock-am/backup:/opt/openam/backup" \
  "$IMAGE_NAME":"$IMAGE_TAG"
