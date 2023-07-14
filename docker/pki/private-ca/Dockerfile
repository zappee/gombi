# ******************************************************************************
# Remal Private Certificate Authority server.
#
# Since : March, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
ARG IMAGE_FROM=${IMAGE_FROM}
ARG BUILD_TYPE="fat"
FROM ${IMAGE_FROM} AS base

EXPOSE 22/tcp
EXPOSE 1331/tcp

# environment variables
ENV IMAGE_NAME="private-ca" \
    IMAGE_TAG="0.0.1-remal" \
    IMAGE_DESCRIPTION="Remal Private Certificate Authority server" \
    IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>" \
    \
    EASYRSA_HOME="/opt/easy-rsa" \
    EASYRSA_INSTALL_KIT="EasyRSA-3.1.2.tgz" \
    \
    EASYRSA_REQ_CN="remal.com" \
    EASYRSA_REQ_COUNTRY="HU" \
    EASYRSA_REQ_PROVINCE="Central Hungary" \
    EASYRSA_REQ_CITY="Budapest" \
    EASYRSA_REQ_ORG="Remal Softwares" \
    EASYRSA_REQ_EMAIL="arnold.somogyi@gmail.com" \
    EASYRSA_REQ_OU="IT Department" \
    EASYRSA_ALGO="ec" \
    EASYRSA_DIGEST="sha256" \
    EASYRSA_KEY_SIZE=2048 \
    EASYRSA_PASS="changeit"

# set image metadata
LABEL "com.remal.image.vendor"="Remal" \
      "com.remal.image.name"="${IMAGE_NAME}" \
      "com.remal.image.version"="${IMAGE_TAG}" \
      "com.remal.image.description"="${IMAGE_DESCRIPTION}" \
      "com.remal.image.author"="${IMAGE_AUTHOR}"


# fat image
FROM base AS base-fat
COPY "bin/$EASYRSA_INSTALL_KIT" "/tmp/"
RUN set -ux; \
    printf "building fat image\n"; \
    mkdir -p "$EASYRSA_HOME"; \
    tar -xvf "/tmp/$EASYRSA_INSTALL_KIT" --strip-components=1 -C "$EASYRSA_HOME"; \
    rm -f "/tmp/$EASYRSA_INSTALL_KIT"


# slim image
FROM base AS base-slim
RUN set -ux; \
    printf "building slim image\n"; \
    hostIp="$(ip route | awk '/default/ { print $3 }')"; \
    wget -O "/tmp/$EASYRSA_INSTALL_KIT" http://$hostIp:8080/docker-build/$EASYRSA_INSTALL_KIT; \
    mkdir -p "$EASYRSA_HOME"; \
    tar -xvf "/tmp/$EASYRSA_INSTALL_KIT" --strip-components=1 -C "$EASYRSA_HOME"; \
    rm -f "/tmp/$EASYRSA_INSTALL_KIT"


# final image
FROM base-$BUILD_TYPE AS final
COPY container-scripts/generate-cert.sh $EASYRSA_HOME/
