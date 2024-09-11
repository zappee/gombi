# ******************************************************************************
#  Remal HashiCorp Consul Docker image build file.
#
#  Since:  October 2023
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
# default build-time values, can be overwritten during the build
ARG IMAGE_FROM="remal-openjdk-21:0.0.1"
ARG BUILD_TYPE="fat"

FROM ${IMAGE_FROM} AS base

EXPOSE 22/tcp
EXPOSE 8501/tcp

# defaultvalue of the scope level build-time variables
ARG IMAGE_NAME="remal-consul"
ARG IMAGE_TAG="0.0.1"
ARG IMAGE_DESCRIPTION="HashiCorp Consul 1.18"
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
    CONSUL_INSTALL_KIT="consul_1.18.2_linux_386.zip" \
    CONSUL_CONFIG_TEMPLATE_DIR="/tmp/consul-config-template" \
    CONSUL_CONFIG_DIR="/tmp/consul-config" \
    CONSUL_DATA_DIR="/tmp/consul-data"

LABEL "image.name"="${IMAGE_NAME}" \
      "image.version"="${IMAGE_TAG}" \
      "image.description"="${IMAGE_DESCRIPTION}" \
      "image.vendor"="${IMAGE_VENDOR}" \
      "image.author"="${IMAGE_AUTHOR}"


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
FROM base-${BUILD_TYPE}
COPY container-scripts/consul-functions.sh /
COPY config/consul-template.json "$CONSUL_CONFIG_TEMPLATE_DIR/"
RUN set -ue; \
    mkdir -p "$CONSUL_DATA_DIR"; \
    mkdir -p "$CONSUL_CONFIG_DIR"; \
    mkdir -p "$CONSUL_CONFIG_TEMPLATE_DIR"
