# ******************************************************************************
# Remal Gafana Monitoring System Docker image build file.
#
# Since:  April 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
# default build-time values, can be overwritten during the build
ARG IMAGE_FROM="remal-base:0.0.1"
ARG BUILD_TYPE="fat"

FROM ${IMAGE_FROM} AS base

EXPOSE 22/tcp
EXPOSE 9090/tcp

# defaultvalue of the scope level build-time variables
ARG IMAGE_NAME="remal-prometheus"
ARG IMAGE_TAG="0.0.1"
ARG IMAGE_DESCRIPTION="Prometheus"
ARG IMAGE_VENDOR="Remal"
ARG IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>"

# environment variables
ENV IMAGE_NAME="${IMAGE_NAME}" \
    IMAGE_TAG="${IMAGE_TAG}" \
    IMAGE_DESCRIPTION="${IMAGE_DESCRIPTION}" \
    IMAGE_VENDOR="${IMAGE_VENDOR}" \
    IMAGE_AUTHOR="${IMAGE_AUTHOR}" \
    \
    PKI_HOST="pki.hello.com" \
    KEYSTORE_HOME="/tmp" \
    CONSUL_HOST="consul.hello.com" \
    \
    PROMETHEUS_INSTALL_KIT="prometheus-2.51.1.linux-amd64.tar.gz" \
    PROMETHEUS_HOME="/opt/prometheus" \
    PROMETHEUS_CONFIG="/opt/prometheus/prometheus.yml" \
    PROMETHEUS_WEB_CONFIG="/opt/prometheus/web-config.yml" \
    PROMETHEUS_LOG="/var/log/prometheus.log" \
    PROMETHEUS_STORAGE="/opt/prometheus/data"

LABEL "image.name"="${IMAGE_NAME}" \
      "image.version"="${IMAGE_TAG}" \
      "image.description"="${IMAGE_DESCRIPTION}" \
      "image.vendor"="${IMAGE_VENDOR}" \
      "image.author"="${IMAGE_AUTHOR}"


# fat image
FROM base AS base-fat
COPY "bin/$PROMETHEUS_INSTALL_KIT" "/tmp/"
RUN set -ue; \
    tar -xvf "/tmp/$PROMETHEUS_INSTALL_KIT" -C "$(dirname "$PROMETHEUS_HOME")"; \
    mv "$(dirname "$PROMETHEUS_HOME")/${PROMETHEUS_INSTALL_KIT/.tar.gz/}" "$PROMETHEUS_HOME"; \
    rm "/tmp/$PROMETHEUS_INSTALL_KIT"


# slim image
FROM base AS base-slim
RUN set -ue; \
    host_ip="$(ip route | awk '/default/ { print $3 }')"; \
    wget -O "/tmp/$PROMETHEUS_INSTALL_KIT" http://$host_ip:8080/docker-build/$PROMETHEUS_INSTALL_KIT; \
    tar -xvf "/tmp/$PROMETHEUS_INSTALL_KIT" -C "$(dirname "$PROMETHEUS_HOME")"; \
    mv "$(dirname "$PROMETHEUS_HOME")/${PROMETHEUS_INSTALL_KIT/.tar.gz/}" "$PROMETHEUS_HOME"; \
    rm "/tmp/$PROMETHEUS_INSTALL_KIT"


# final image
FROM base-${BUILD_TYPE}
RUN set -ue; \
    mkdir -p "$PROMETHEUS_STORAGE"
COPY config/*.yml "$PROMETHEUS_HOME/"
