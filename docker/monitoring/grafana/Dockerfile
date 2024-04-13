# ******************************************************************************
# Remal Gafana Monitoring System Docker image build file.
#
# Since:  April 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
ARG IMAGE_FROM=${IMAGE_FROM}
ARG BUILD_TYPE="fat"
FROM ${IMAGE_FROM} AS base

EXPOSE 22/tcp
EXPOSE 3000/tcp

# environment variables
ENV IMAGE_NAME="remal-grafana" \
    IMAGE_TAG="0.0.1-remal" \
    IMAGE_DESCRIPTION="Remal Grafana" \
    IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>" \
    \
    PKI_HOST="pki.hello.com" \
    KEYSTORE_HOME="/tmp" \
    PROMETHEUS_HOST="consul.hello.com" \
    \
    GRAFANA_INSTALL_KIT="grafana-enterprise-10.4.2.linux-amd64.tar.gz" \
    GRAFANA_HOME="/opt/grafana" \
    GRAFANA_CONFIG="/opt/grafana/conf/custom.ini" \
    GRAFANA_PROVISIONING="/opt/grafana/conf/provisioning" \
    GRAFANA_STORAGE="/opt/grafana/data" \
    GRAFANA_LOG="/var/log/grafana" \
    GRAFANA_PLUGINS="/opt/grafana/data/plugins" \
    GRAFANA_ADMIN_PASSWORD="password"

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
    tar -xvf "/tmp/$GRAFANA_INSTALL_KIT" -C "$(dirname "$GRAFANA_HOME")"; \
    version=$(basename $GRAFANA_INSTALL_KIT | awk -F"-" '{ print $3 }'); \
    version="${version%.*}"; \
    printf "grafana version: %s\n" "$version"; \
    mv "$(dirname "$GRAFANA_HOME")/grafana-v${version}" "$GRAFANA_HOME"; \
    rm "/tmp/$GRAFANA_INSTALL_KIT"


# slim image
FROM base AS base-slim
RUN set -ue; \
    host_ip="$(ip route | awk '/default/ { print $3 }')"; \
    wget -O "/tmp/$GRAFANA_INSTALL_KIT" http://$host_ip:8080/docker-build/$GRAFANA_INSTALL_KIT; \
    tar -xvf "/tmp/$GRAFANA_INSTALL_KIT" -C "$(dirname "$GRAFANA_HOME")"; \
    version=$(basename $GRAFANA_INSTALL_KIT | awk -F"-" '{ print $3 }'); \
    version="${version%.*}"; \
    printf "grafana version: %s\n" "$version"; \
    mv "$(dirname "$GRAFANA_HOME")/grafana-v${version}" "$GRAFANA_HOME"; \
    rm "/tmp/$GRAFANA_INSTALL_KIT"


# final image
FROM base-$BUILD_TYPE AS final
RUN set -ue; \
    mkdir -p "$GRAFANA_STORAGE"; \
    mkdir -p "$GRAFANA_LOG"
COPY config/custom.ini "$GRAFANA_CONFIG"
