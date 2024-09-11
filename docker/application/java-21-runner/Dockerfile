# ******************************************************************************
# Remal Java Executable JAR runner image build file.
# This container is optimalized for running a Spring-Boot JAR.
#
# Since:  February 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
# default build-time values, can be overwritten during the build
ARG IMAGE_FROM="remal-consul:0.0.1"
ARG BUILD_TYPE="fat"

FROM ${IMAGE_FROM} AS base

EXPOSE 22/tcp
EXPOSE 443/tcp
EXPOSE 8500/tcp
EXPOSE 8501/tcp

# defaultvalue of the scope level build-time variables
ARG IMAGE_NAME="remal-java-21-runner"
ARG IMAGE_TAG="0.0.1"
ARG IMAGE_DESCRIPTION="Remal Java 21 Runner"
ARG IMAGE_VENDOR="Remal"
ARG IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>"

# environment variables
ENV IMAGE_NAME="${IMAGE_NAME}" \
    IMAGE_TAG="${IMAGE_TAG}" \
    IMAGE_DESCRIPTION="${IMAGE_DESCRIPTION}" \
    IMAGE_VENDOR="${IMAGE_VENDOR}" \
    IMAGE_AUTHOR="${IMAGE_AUTHOR}" \
    \
    PKI_HOST="pki.remal.com" \
    KEYSTORE_HOME="/tmp" \
    CONSUL_SERVER_HOSTNAME="consul.hello.com" \
    KAFKA_SERVERS="kafka-1.hello.com:9092, kafka-2.hello.com:9092" \
    \
    JAR_HOME="/jar-to-run" \
    JAVA_OPTS="-Xms512m -Xmx512m -XX:+UseZGC" \
    JAVA_DEBUG="true" \
    JAVA_DEBUG_PORT=8000 \
    \
    HEALTH_CHECK="true" \
    HEALTH_CHECK_URI="https://localhost:8443/actuator/health" \
    EXPECTED_HEALTH_CHECK_STATE='\"status\":\"UP\"'

LABEL "image.name"="${IMAGE_NAME}" \
      "image.version"="${IMAGE_TAG}" \
      "image.description"="${IMAGE_DESCRIPTION}" \
      "image.vendor"="${IMAGE_VENDOR}" \
      "image.author"="${IMAGE_AUTHOR}"


# fat image
FROM base AS base-fat


# slim image
FROM base AS base-slim


# final image
FROM base-${BUILD_TYPE}

# installing tools
RUN set -ue; \
    apk add --no-cache curl

COPY config/consul-template.json "$CONSUL_CONFIG_TEMPLATE_DIR/"
COPY container-scripts/init/* /docker.init/
COPY container-scripts/startup/* /docker.startup/
