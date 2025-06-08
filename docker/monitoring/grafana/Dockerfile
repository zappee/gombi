# ******************************************************************************
# Remal Gafana Monitoring System Docker image build file.
#
# Since:  April 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
ARG IMAGE_FROM="not-set"
ARG BUILD_TYPE="fat"
FROM ${IMAGE_FROM} AS base

EXPOSE 22/tcp
EXPOSE 3000/tcp

# environment variables
ENV IMAGE_NAME="remal-grafana" \
    IMAGE_TAG="0.0.1" \
    IMAGE_DESCRIPTION="Remal Grafana" \
    IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>" \
    \
    PKI_HOST="pki.hello.com" \
    KEYSTORE_HOME="/tmp" \
    PROMETHEUS_HOST="prometheus.hello.com" \
    PROMETHEUS_PORT="9090" \
    PROMETHEUS_PROTOCOL="https" \
    \
    GRAFANA_INSTALL_KIT="grafana-enterprise-12.0.1.linux-amd64.tar.gz" \
    GRAFANA_HOME="/opt/grafana" \
    GRAFANA_PROTOCOL="https" \
    GRAFANA_PORT=3000 \
    GRAFANA_CONFIG="/opt/grafana/conf/custom.ini" \
    GRAFANA_PROVISIONING="/opt/grafana/conf/provisioning" \
    GRAFANA_STORAGE="/opt/grafana/data" \
    GRAFANA_LOG_DIR="/var/log/grafana" \
    GRAFANA_PLUGINS="/opt/grafana/data/plugins" \
    GRAFANA_USER="admin" \
    GRAFANA_PASSWORD="password"

# set image metadata
LABEL "com.remal.image.vendor"="Remal" \
      "com.remal.image.name"="${IMAGE_NAME}" \
      "com.remal.image.version"="${IMAGE_TAG}" \
      "com.remal.image.description"="${IMAGE_DESCRIPTION}" \
      "com.remal.image.author"="${IMAGE_AUTHOR}"


# fat image
FROM base AS base-fat
COPY "bin/$GRAFANA_INSTALL_KIT" "/tmp/"
RUN set -ue; \
    mkdir -p "$GRAFANA_HOME"; \
    tar -xvf "/tmp/$GRAFANA_INSTALL_KIT" -C "$GRAFANA_HOME" --strip-components=1; \
    rm "/tmp/$GRAFANA_INSTALL_KIT"


# slim image
FROM base AS base-slim
RUN set -ue; \
    host_ip="$(ip route | awk '/default/ { print $3 }')"; \
    wget -O "/tmp/$GRAFANA_INSTALL_KIT" http://$host_ip:8080/docker-build/$GRAFANA_INSTALL_KIT; \
    mkdir -p "$GRAFANA_HOME"; \
    tar -xvf "/tmp/$GRAFANA_INSTALL_KIT" -C "$GRAFANA_HOME" --strip-components=1; \
    rm "/tmp/$GRAFANA_INSTALL_KIT"


# final image
FROM base-$BUILD_TYPE AS final
RUN set -ue; \
    mkdir -p "$GRAFANA_STORAGE"; \
    mkdir -p "$GRAFANA_LOG_DIR"; \
    mkdir -p "$GRAFANA_PLUGINS"; \
    apk --no-cache add curl
COPY container-scripts/grafana-functions.sh /
COPY config/custom.ini "$GRAFANA_CONFIG"
COPY config/datasources/* "$GRAFANA_HOME/customization/datasources/"
