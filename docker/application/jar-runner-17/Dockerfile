# ******************************************************************************
#  Remal Java Executable JAR runner.
#  This container is optimalized for running a Spring-Boot JAR.
#
#  Since : February, 2024
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
ARG IMAGE_FROM=${IMAGE_FROM}
ARG BUILD_TYPE="fat"
FROM ${IMAGE_FROM} AS base

EXPOSE 22/tcp
EXPOSE 443/tcp

# environment variables
ENV IMAGE_NAME="java-17-runner" \
    IMAGE_TAG="0.0.1-remal" \
    IMAGE_DESCRIPTION="Remal Java 17 Runner" \
    IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>" \
    \
    PKI_HOST="pki.remal.com" \
    KEYSTORE_HOME="/tmp" \
    CONSUL_SERVER_HOSTNAME="consul.hello.com" \
    JAR_HOME="/jars-to-run"

# set image metadata
LABEL "com.remal.image.vendor"="Remal" \
      "com.remal.image.name"="${IMAGE_NAME}" \
      "com.remal.image.version"="${IMAGE_TAG}" \
      "com.remal.image.description"="${IMAGE_DESCRIPTION}" \
      "com.remal.image.author"="${IMAGE_AUTHOR}"

COPY config/consul-template.json "$CONSUL_CONFIG_TEMPLATE_DIR/"
COPY container-scripts/init/* /docker.init/
COPY container-scripts/startup/* /docker.startup/
