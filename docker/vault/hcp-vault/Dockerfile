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
    VAULT_CONFIG_FILE="/etc/vault.hcl" \
    VAULT_FILE_STORE="/opt/vault/data" \
    VAULT_API_PORT="8200" \
    VAULT_LOG_LEVEL="info"

# set image metadata
LABEL "com.remal.image.vendor"="Remal" \
      "com.remal.image.name"="${IMAGE_NAME}" \
      "com.remal.image.version"="${IMAGE_TAG}" \
      "com.remal.image.description"="${IMAGE_DESCRIPTION}" \
      "com.remal.image.author"="${IMAGE_AUTHOR}"

# installing tools
RUN set -ux; \
    apk add --no-cache openssl


# fat image
FROM base AS base-fat


# slim image
FROM base AS base-slim


# final image
FROM base-$BUILD_TYPE AS final
COPY config/vault.hcl "$VAULT_CONFIG_FILE"
COPY container-scripts/vault-functions.sh /
