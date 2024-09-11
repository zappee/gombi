# ******************************************************************************
# Remal Private Certificate Authority server.
#
# Since:  March 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
# default build-time values, can be overwritten during the build
ARG IMAGE_FROM="remal-openjdk-17:0.0.1"
ARG BUILD_TYPE="fat"

FROM ${IMAGE_FROM} AS base

EXPOSE 22/tcp
EXPOSE 1331/tcp

# defaultvalue of the scope level build-time variables
ARG IMAGE_NAME="remal-private-ca"
ARG IMAGE_TAG="0.0.1"
ARG IMAGE_DESCRIPTION="Private Certificate Authority server"
ARG IMAGE_VENDOR="Remal"
ARG IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>"

# environment variables
ENV IMAGE_NAME="${IMAGE_NAME}" \
    IMAGE_TAG="${IMAGE_TAG}" \
    IMAGE_DESCRIPTION="${IMAGE_DESCRIPTION}" \
    IMAGE_VENDOR="${IMAGE_VENDOR}" \
    IMAGE_AUTHOR="${IMAGE_AUTHOR}" \
    \
    EASYRSA_HOME="/opt/easy-rsa" \
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

LABEL "image.name"="${IMAGE_NAME}" \
      "image.version"="${IMAGE_TAG}" \
      "image.description"="${IMAGE_DESCRIPTION}" \
      "image.vendor"="${IMAGE_VENDOR}" \
      "image.author"="${IMAGE_AUTHOR}"


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
FROM base-${BUILD_TYPE}
COPY container-scripts/generate-cert.sh $EASYRSA_HOME/
