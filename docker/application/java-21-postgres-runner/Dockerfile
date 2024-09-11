# ******************************************************************************
# Remal Java Executable JAR runner with Postgres database server image build
# file.
#
# Since:  April 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
# default build-time values, can be overwritten during the build
ARG IMAGE_FROM="remal-java-21-runner:0.0.1"
ARG BUILD_TYPE="fat"

FROM ${IMAGE_FROM} AS base

EXPOSE 22/tcp
EXPOSE 3000/tcp
EXPOSE 5432/tcp

# defaultvalue of the scope level build-time variables
ARG IMAGE_NAME="remal-java-21-postgres-runner"
ARG IMAGE_TAG="0.0.1"
ARG IMAGE_DESCRIPTION="Remal Java 21 Runner with Postgres database server"
ARG IMAGE_VENDOR="Remal"
ARG IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>"

# environment variables
ENV IMAGE_NAME="${IMAGE_NAME}" \
    IMAGE_TAG="${IMAGE_TAG}" \
    IMAGE_DESCRIPTION="${IMAGE_DESCRIPTION}" \
    IMAGE_VENDOR="${IMAGE_VENDOR}" \
    IMAGE_AUTHOR="${IMAGE_AUTHOR}" \
    \
    POSTGRES_HOME="/var/lib/postgresql" \
    POSTGRES_DATA="/var/lib/postgresql/data" \
    POSTGRES_LOG_DIR="/var/log/postgresql" \
    POSTGRES_CONFIG="/var/lib/postgresql/data/postgresql.conf" \
    START_DB="false" \
    \
    DB_ADMIN_USER="postgres" \
    DB_ADMIN_PASSWORD="password" \
    \
    DB_APP_DATABASE="app" \
    DB_APP_USER="application" \
    DB_APP_PASSWORD="password"

LABEL "image.name"="${IMAGE_NAME}" \
      "image.version"="${IMAGE_TAG}" \
      "image.description"="${IMAGE_DESCRIPTION}" \
      "image.vendor"="${IMAGE_VENDOR}" \
      "image.author"="${IMAGE_AUTHOR}"


# fat image
FROM base AS base-fat


# slim image
FROM base AS base-slim


# final image
FROM base-${BUILD_TYPE}

# installing tools
RUN set -ue; \
    apk update; \
    apk add --no-cache curl; \
    apk add --no-cache postgresql16; \
    mkdir /run/postgresql; \
    chown postgres:postgres /run/postgresql/

# configure postgres
USER postgres:postgres
RUN set -ue; \
    mkdir "$POSTGRES_DATA"; \
    initdb -D "$POSTGRES_DATA"
COPY --chown=postgres:postgres config/*.conf $POSTGRES_DATA/

USER root:root
COPY container-scripts/init/* /docker.init/
COPY container-scripts/startup/* /docker.startup/
COPY container-scripts/postgres-functions.sh /
