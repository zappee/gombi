# ******************************************************************************
#  Remal HashiCorp Consul Docker image build file.
#
#  Since:  October 2023
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
ARG IMAGE_FROM="unknown"
ARG BUILD_TYPE="fat"
FROM ${IMAGE_FROM} AS base

EXPOSE 22/tcp
EXPOSE 8501/tcp

ARG IMAGE_NAME="N/A"
ARG IMAGE_TAG="N/A"
ARG IMAGE_AUTHOR="N/A"
ARG IMAGE_DESCRIPTION="N/A"

# environment variables
ENV IMAGE_NAME="$IMAGE_NAME" \
    IMAGE_TAG="$IMAGE_TAG" \
    IMAGE_AUTHOR="$IMAGE_AUTHOR" \
    IMAGE_DESCRIPTION="$IMAGE_DESCRIPTION" \
    \
    PKI_HOST="pki.remal.com" \
    KEYSTORE_HOME="/tmp" \
    \
    CONSUL_INSTALL_KIT="consul_1.21.1_linux_386.zip" \
    CONSUL_CONFIG_TEMPLATE_DIR="/tmp/consul-config-template" \
    CONSUL_CONFIG_DIR="/tmp/consul-config" \
    CONSUL_DATA_DIR="/tmp/consul-data"

# set image metadata
LABEL "com.remal.image.name"="$IMAGE_NAME" \
      "com.remal.image.tag"="$IMAGE_TAG" \
      "com.remal.image.author"="$IMAGE_AUTHOR" \
      "com.remal.image.description"="$IMAGE_DESCRIPTION" \
      "com.remal.image.vendor"="Remal"


# fat image
FROM base AS base-fat
COPY "bin/$CONSUL_INSTALL_KIT" "/tmp/"
RUN set -ue; \
    unzip "/tmp/$CONSUL_INSTALL_KIT" -d "/usr/local/bin/"; \
    rm "/tmp/$CONSUL_INSTALL_KIT"


# slim image
FROM base AS base-slim
RUN set -ue; \
    host_ip="$(ip route | awk '/default/ { print $3 }')"; \
    wget -O "/tmp/$CONSUL_INSTALL_KIT" http://$host_ip:8080/docker-build/$CONSUL_INSTALL_KIT; \
    unzip "/tmp/$CONSUL_INSTALL_KIT" -d "/usr/local/bin/"; \
    rm "/tmp/$CONSUL_INSTALL_KIT"


# final image
FROM base-$BUILD_TYPE AS final
COPY container-scripts/consul-functions.sh /
COPY config/consul-template.json "$CONSUL_CONFIG_TEMPLATE_DIR/"
RUN set -ue; \
    mkdir -p "$CONSUL_DATA_DIR"; \
    mkdir -p "$CONSUL_CONFIG_DIR"; \
    mkdir -p "$CONSUL_CONFIG_TEMPLATE_DIR"
