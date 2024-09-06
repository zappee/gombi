# ******************************************************************************
# Remal Private Certificate Authority server.
#
# Since : March, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
ARG IMAGE_FROM
ARG BUILD_TYPE
FROM ${IMAGE_FROM:-remal-base:0.0.1} AS base

EXPOSE 22/tcp
EXPOSE 1331/tcp

# build-time variables
ARG IMAGE_NAME
ARG IMAGE_TAG
ARG IMAGE_DESCRIPTION

# environment variables
ENV EASYRSA_HOME="/opt/easy-rsa" \
    EASYRSA_INSTALL_KIT="EasyRSA-3.1.7.tgz" \
    \
    EASYRSA_REQ_CN="remal.com" \
    EASYRSA_REQ_COUNTRY="HU" \
    EASYRSA_REQ_PROVINCE="Central Hungary" \
    EASYRSA_REQ_CITY="Budapest" \
    EASYRSA_REQ_ORG="Remal Software" \
    EASYRSA_REQ_EMAIL="arnold.somogyi@gmail.com" \
    EASYRSA_REQ_OU="IT Department" \
    EASYRSA_ALGO="ec" \
    EASYRSA_DIGEST="sha256" \
    EASYRSA_KEY_SIZE=2048 \
    EASYRSA_PASS="changeit"

# set image metadata
LABEL "com.remal.image.name"="${IMAGE_NAME}" \
      "com.remal.image.version"="${IMAGE_TAG}" \
      "com.remal.image.description"="${IMAGE_DESCRIPTION}" \
      "com.remal.image.vendor"="Remal" \
      "com.remal.image.author"="Arnold Somogyi <arnold.somogyi@gmail.com>"


# fat image
FROM base AS base-fat
COPY "bin/$EASYRSA_INSTALL_KIT" "/tmp/"
RUN set -ue; \
    printf "building fat image\n"; \
    printf "Easy RSA version: %s\n" "$EASYRSA_INSTALL_KIT"; \
    ls -all "/tmp/"; \
    mkdir -p "$EASYRSA_HOME"; \
    tar -xvf "/tmp/$EASYRSA_INSTALL_KIT" --strip-components=1 -C "$EASYRSA_HOME"; \
    rm -f "/tmp/$EASYRSA_INSTALL_KIT"


# slim image
FROM base AS base-slim
RUN set -ue; \
    printf "building slim image\n"; \
    host_ip="$(ip route | awk '/default/ { print $3 }')"; \
    wget -O "/tmp/$EASYRSA_INSTALL_KIT" http://$host_ip:8080/docker-build/$EASYRSA_INSTALL_KIT; \
    mkdir -p "$EASYRSA_HOME"; \
    tar -xvf "/tmp/$EASYRSA_INSTALL_KIT" --strip-components=1 -C "$EASYRSA_HOME"; \
    rm -f "/tmp/$EASYRSA_INSTALL_KIT"


# final image
FROM base-${BUILD_TYPE:-fat}
COPY container-scripts/generate-cert.sh $EASYRSA_HOME/
