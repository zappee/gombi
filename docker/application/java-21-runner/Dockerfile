# ******************************************************************************
# Remal Java Executable JAR runner image build file.
# This container is optimalized for running a Spring-Boot JAR.
#
# Since:  February 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
ARG IMAGE_FROM=${IMAGE_FROM}
ARG BUILD_TYPE="fat"
FROM ${IMAGE_FROM} AS base

EXPOSE 22/tcp
EXPOSE 443/tcp
EXPOSE 8500/tcp
EXPOSE 8501/tcp

# environment variables
ENV IMAGE_NAME="java-21-runner" \
    IMAGE_TAG="0.0.1" \
    IMAGE_DESCRIPTION="Remal Java 21 Runner" \
    IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>" \
    \
    PKI_HOST="pki.remal.com" \
    KEYSTORE_HOME="/tmp" \
    CONSUL_SERVER_HOSTNAME="consul.hello.com" \
    \
    JAR_HOME="/jar-to-run" \
    JAVA_OPTS="-Xms512m -Xmx512m -XX:+UseZGC" \
    JAVA_DEBUG="true" \
    JAVA_DEBUG_PORT=8000 \
    \
    HEALTH_CHECK="true" \
    HEALTH_CHECK_URI="https://localhost:8443/actuator/health" \
    EXPECTED_HEALTH_CHECK_STATE='\"status\":\"UP\"'

# set image metadata
LABEL "com.remal.image.vendor"="Remal" \
      "com.remal.image.name"="${IMAGE_NAME}" \
      "com.remal.image.version"="${IMAGE_TAG}" \
      "com.remal.image.description"="${IMAGE_DESCRIPTION}" \
      "com.remal.image.author"="${IMAGE_AUTHOR}"


# fat image
FROM base AS base-fat


# slim image
FROM base AS base-slim


# final image
FROM base-$BUILD_TYPE AS final
# installing tools
RUN set -ue; \
    apk add --no-cache curl

COPY config/consul-template.json "$CONSUL_CONFIG_TEMPLATE_DIR/"
COPY container-scripts/init/* /docker.init/
COPY container-scripts/startup/* /docker.startup/
