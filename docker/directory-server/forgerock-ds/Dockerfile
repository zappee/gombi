# ******************************************************************************
#  Remal ForgeRock Directory Server Docker image build file.
#
#  Since : January, 2023
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
ARG IMAGE_FROM=${IMAGE_FROM}
ARG BUILD_TYPE="fat"
FROM ${IMAGE_FROM} AS base

EXPOSE 22/tcp
EXPOSE 389/tcp
EXPOSE 636/tcp
EXPOSE 4444/tcp
EXPOSE 1331/tcp

# build time variables
ARG DS_HOME="/opt/opendj"

# environment variables
ENV IMAGE_NAME="ds-7.3" \
    IMAGE_TAG="0.0.1-remal" \
    IMAGE_DESCRIPTION="Remal ForgeRock Directory Server 7.3.0" \
    IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>" \
    \
    AM_IDENTITY_STORE_NAME="am-identity-store" \
    AM_CONFIG_STORE_NAME="am-config" \
    \
    NEW_DS_DEPLOYMENT_KEY="false" \
    \
    DS_CONFIG_BACKUP="true" \
    DS_CONFIG_RESTORE_FROM="latest" \
    AM_IDENTITY_STORE_BACKUP="true" \
    AM_IDENTITY_STORE_RESTORE_FROM="latest" \
    AM_CONFIG_STORE_BACKUP="true" \
    AM_CONFIG_STORE_RESTORE_FROM="latest" \
    \
    ADMIN_CONNECTOR_PORT=4444 \
    PKI_HOST="ca.remal.com" \
    DS_HOST="ds.hello.com" \
    DS_HOME="$DS_HOME" \
    DEPLOYMENT_KEY_FILE="$DS_HOME/deployment-key.properties" \
    DS_INSTALL_KIT="DS-7.3.0.zip" \
    LDAP_PORT=389 \
    LDAP_USER_DN="uid=admin" \
    LDAP_USER_PASSWORD="password" \
    LDAPS_PORT=636

# set image metadata
LABEL "com.remal.image.vendor"="Remal" \
      "com.remal.image.name"="${IMAGE_NAME}" \
      "com.remal.image.version"="${IMAGE_TAG}" \
      "com.remal.image.description"="${IMAGE_DESCRIPTION}" \
      "com.remal.image.author"="${IMAGE_AUTHOR}"


# fat image
FROM base AS base-fat
COPY "bin/$DS_INSTALL_KIT" "/tmp/"
RUN unzip "/tmp/$DS_INSTALL_KIT" -d "/opt/"


# slim image
FROM base AS base-slim
RUN set -ux; \
    hostIp="$(ip route | awk '/default/ { print $3 }')"; \
    wget -O "/tmp/$DS_INSTALL_KIT" http://$hostIp:8080/docker-build/$DS_INSTALL_KIT; \
    unzip "/tmp/$DS_INSTALL_KIT" -d "/opt/"; \
    rm "/tmp/$DS_INSTALL_KIT"


# final image
FROM base-$BUILD_TYPE AS final
COPY container-scripts/ds-functions.sh container-scripts/shutdown-actions.sh /
COPY config/deployment-key.properties "$DS_HOME/"
