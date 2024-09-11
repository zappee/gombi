# ******************************************************************************
# Remal HashiCorp Vault Docker image build file.
#
# Since:  July 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
# default build-time values, can be overwritten during the build
ARG IMAGE_FROM="remal-base:0.0.1"
ARG BUILD_TYPE="fat"

FROM ${IMAGE_FROM} AS base

EXPOSE 22/tcp
EXPOSE 8200/tcp

# defaultvalue of the scope level build-time variables
ARG IMAGE_NAME="remal-vault"
ARG IMAGE_TAG="0.0.1"
ARG IMAGE_DESCRIPTION="HashiCorp Vault 1.14"
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
    VAULT_INSTALL_KIT="vault_1.15.0_linux_386.zip" \
    VAULT_CONFIG_FILE="/etc/vault.hcl" \
    VAULT_INIT_LOG="/var/log/vault-tokens.txt" \
    VAULT_FILE_STORE="/opt/vault/data" \
    VAULT_API_PORT="8200" \
    VAULT_LOG_LEVEL="info" \
    VAULT_LOG="/var/log/vault.log" \
    VAULT_AUDIT_LOG="/var/log/vault-audit.log"

LABEL "image.name"="${IMAGE_NAME}" \
      "image.version"="${IMAGE_TAG}" \
      "image.description"="${IMAGE_DESCRIPTION}" \
      "image.vendor"="${IMAGE_VENDOR}" \
      "image.author"="${IMAGE_AUTHOR}"

# install openssl
RUN set -ue; \
    apk add --no-cache openssl


# fat image
FROM base AS base-fat
COPY "bin/$VAULT_INSTALL_KIT" "/tmp/"
RUN set -ue; \
    unzip "/tmp/$VAULT_INSTALL_KIT" -d "/usr/local/bin/"; \
    rm "/tmp/$VAULT_INSTALL_KIT"


# slim image
FROM base AS base-slim
RUN set -ue; \
    host_ip="$(ip route | awk '/default/ { print $3 }')"; \
    wget -O "/tmp/$VAULT_INSTALL_KIT" http://$host_ip:8080/docker-build/$VAULT_INSTALL_KIT; \
    unzip "/tmp/$VAULT_INSTALL_KIT" -d "/usr/local/bin/"; \
    rm "/tmp/$VAULT_INSTALL_KIT"


# final image
FROM base-${BUILD_TYPE}
COPY config/vault.hcl "$VAULT_CONFIG_FILE"
COPY container-scripts/vault-functions.sh container-scripts/get-value.sh container-scripts/set-value.sh /
