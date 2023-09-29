# ******************************************************************************
#  Remal HashiCorp Vault Docker image build file.
#
#  Since : -july, 2023
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
ARG IMAGE_FROM=${IMAGE_FROM}
ARG BUILD_TYPE="fat"
FROM ${IMAGE_FROM} AS base

EXPOSE 22/tcp
EXPOSE 8200/tcp

# environment variables
ENV IMAGE_NAME="vault-1.14" \
    IMAGE_TAG="0.0.1-remal" \
    IMAGE_DESCRIPTION="HashiCorp Vault 1.14.0" \
    IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>" \
    \
    PKI_HOST="pki.remal.com" \
    KEYSTORE_HOME="/tmp" \
    \
    VAULT_INSTALL_KIT="vault_1.15.0_linux_386.zip" \
    VAULT_CONFIG_FILE="/etc/vault.hcl" \
    VAULT_INIT_LOG="/var/log/vault-tokens.txt" \
    VAULT_FILE_STORE="/opt/vault/data" \
    VAULT_API_PORT="8200" \
    VAULT_LOG_LEVEL="info"

# set image metadata
LABEL "com.remal.image.vendor"="Remal" \
      "com.remal.image.name"="${IMAGE_NAME}" \
      "com.remal.image.version"="${IMAGE_TAG}" \
      "com.remal.image.description"="${IMAGE_DESCRIPTION}" \
      "com.remal.image.author"="${IMAGE_AUTHOR}"

# install openssl
RUN set -ux; \
    apk add --no-cache openssl


# fat image
FROM base AS base-fat
COPY "bin/$VAULT_INSTALL_KIT" "/tmp/"
RUN set -ux; \
    unzip "/tmp/$VAULT_INSTALL_KIT" -d "/usr/local/bin/"; \
    rm "/tmp/$VAULT_INSTALL_KIT"


# slim image
FROM base AS base-slim
RUN set -ux; \
    hostIp="$(ip route | awk '/default/ { print $3 }')"; \
    wget -O "/tmp/$VAULT_INSTALL_KIT" http://$hostIp:8080/docker-build/$VAULT_INSTALL_KIT; \
    unzip "/tmp/$VAULT_INSTALL_KIT" -d "/usr/local/bin/"; \
    rm "/tmp/$VAULT_INSTALL_KIT"


# final image
FROM base-$BUILD_TYPE AS final
COPY config/vault.hcl "$VAULT_CONFIG_FILE"
COPY container-scripts/vault-functions.sh  container-scripts/get-value.sh container-scripts/set-value.sh /
