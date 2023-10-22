#!/bin/bash -ue
# ******************************************************************************
# Remal Apache Tomcat 9 Docker container deployer file.
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
  --env JAVA_OPTIONS="-Xms512m -Xmx512m -XX:+UseParallelGC" \
  --publish 13022:22 \
  --publish 13080:8080 \
  "$IMAGE_NAME":"$IMAGE_TAG"
