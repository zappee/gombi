# ******************************************************************************
# Remal Hazelcast Platform Docker image build file.
#
# Since:  August 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Hazelcast ports:
#    -  5555: hazelcast public address of a member
#    -  5701: hazelcast uses to communicate between cluster members
#    - 54327: used to discover Hazelcast members
#    - 34500: hazelcast outbound-port
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
# default build-time values, can be overwritten during the build
ARG IMAGE_FROM="remal-openjdk-21:0.0.1"
ARG BUILD_TYPE="fat"

FROM ${IMAGE_FROM} AS base

EXPOSE 22/tcp
EXPOSE 5555/tcp
EXPOSE 5701/tcp

# defaultvalue of the scope level build-time variables
ARG IMAGE_NAME="remal-hazelcast"
ARG IMAGE_TAG="0.0.1"
ARG IMAGE_DESCRIPTION="Hazelcast Platform Distributed Cache"
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
    \
    HAZELCAST_HOME="/opt/hazelcast" \
    HAZELCAST_CONFIG_TEMPLATE_DIR="/tmp/hazelcast-config-template" \
    HAZELCAST_INSTALL_KIT="hazelcast-5.5.0-slim.tar.gz" \
    HAZELCAST_CLUSTER_NAME="gombi-dev"

LABEL "image.name"="${IMAGE_NAME}" \
      "image.version"="${IMAGE_TAG}" \
      "image.description"="${IMAGE_DESCRIPTION}" \
      "image.vendor"="${IMAGE_VENDOR}" \
      "image.author"="${IMAGE_AUTHOR}"

# installing tools and settin up bash as a default shell
RUN set -ue; \
    apk add --no-cache curl


# fat image
FROM base AS base-fat
LABEL "com.remal.image.type"="fat"
COPY "bin/$HAZELCAST_INSTALL_KIT" "/tmp/"
RUN set -ue; \
    printf "building the fat image\n"; \
    mkdir -p "$HAZELCAST_HOME"; \
    tar -xvf "/tmp/$HAZELCAST_INSTALL_KIT" --strip-components=1 -C "$HAZELCAST_HOME"; \
    rm -f "/tmp/$HAZELCAST_INSTALL_KIT"


# slim image
FROM base AS base-slim
LABEL "com.remal.image.type"="slim"
RUN set -ue; \
    printf "building the slim image\n"; \
    host_ip="$(ip route | awk '/default/ { print $3 }')"; \
    wget -O "/tmp/$HAZELCAST_INSTALL_KIT" http://$host_ip:8080/docker-build/$HAZELCAST_INSTALL_KIT; \
    mkdir -p "$HAZELCAST_HOME"; \
    tar -xvf "/tmp/$HAZELCAST_INSTALL_KIT" --strip-components=1 -C "$HAZELCAST_HOME"; \
    rm -f "/tmp/$HAZELCAST_INSTALL_KIT"


# final image
FROM base-${BUILD_TYPE}
COPY container-scripts/hazelcast-functions.sh /
COPY config/hazelcast.xml "$HAZELCAST_CONFIG_TEMPLATE_DIR"/
