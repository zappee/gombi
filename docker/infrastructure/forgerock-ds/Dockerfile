# ******************************************************************************
# Remal ForgeRock Directory Server Docker image build file.
#
# Since:  January 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
# default build-time values, can be overwritten during the build
ARG IMAGE_FROM="remal-openjdk-17:0.0.1"
ARG BUILD_TYPE="fat"

FROM ${IMAGE_FROM} AS base

EXPOSE 22/tcp
EXPOSE 389/tcp
EXPOSE 636/tcp
EXPOSE 4444/tcp
EXPOSE 1331/tcp

# defaultvalue of the scope level build-time variables
ARG IMAGE_NAME="remal-ds-7.3"
ARG IMAGE_TAG="0.0.1"
ARG IMAGE_DESCRIPTION="ForgeRock Directory Server 7.3.0"
ARG IMAGE_VENDOR="Remal"
ARG IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>"
ARG DS_HOME="/opt/opendj"

# environment variables
ENV IMAGE_NAME="${IMAGE_NAME}" \
    IMAGE_TAG="${IMAGE_TAG}" \
    IMAGE_DESCRIPTION="${IMAGE_DESCRIPTION}" \
    IMAGE_VENDOR="${IMAGE_VENDOR}" \
    IMAGE_AUTHOR="${IMAGE_AUTHOR}" \
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
    PKI_HOST="pki.remal.com" \
    DS_HOST="ds.hello.com" \
    DS_HOME="$DS_HOME" \
    DEPLOYMENT_KEY_FILE="$DS_HOME/deployment-key.properties" \
    DS_INSTALL_KIT="DS-7.3.0.zip" \
    LDAP_PORT=389 \
    LDAP_USER_DN="uid=admin" \
    LDAP_USER_PASSWORD="password" \
    LDAPS_PORT=636

LABEL "image.name"="${IMAGE_NAME}" \
      "image.version"="${IMAGE_TAG}" \
      "image.description"="${IMAGE_DESCRIPTION}" \
      "image.vendor"="${IMAGE_VENDOR}" \
      "image.author"="${IMAGE_AUTHOR}"


# fat image
FROM base AS base-fat
COPY "bin/$DS_INSTALL_KIT" "/tmp/"
RUN unzip "/tmp/$DS_INSTALL_KIT" -d "/opt/"


# slim image
FROM base AS base-slim
RUN set -ue; \
    host_ip="$(ip route | awk '/default/ { print $3 }')"; \
    wget -O "/tmp/$DS_INSTALL_KIT" http://$host_ip:8080/docker-build/$DS_INSTALL_KIT; \
    unzip "/tmp/$DS_INSTALL_KIT" -d "/opt/"; \
    rm "/tmp/$DS_INSTALL_KIT"


# final image
FROM base-${BUILD_TYPE}
COPY container-scripts/ds-functions.sh container-scripts/shutdown-actions.sh /
COPY config/deployment-key.properties "$DS_HOME/"
