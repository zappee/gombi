# ******************************************************************************
# Remal Java Executable JAR runner with Postgres database server image build
# file.
#
# Since:  April 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
ARG IMAGE_FROM="not-set"
ARG BUILD_TYPE="fat"
FROM ${IMAGE_FROM} AS base

EXPOSE 22/tcp
EXPOSE 3000/tcp
EXPOSE 5432/tcp

# environment variables
ENV IMAGE_NAME="remal-java-21-postgres-runner" \
    IMAGE_TAG="0.0.2" \
    IMAGE_DESCRIPTION="Remal Java 21 Runner with Postgres database server" \
    IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>" \
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

# set image metadata
LABEL "com.remal.image.vendor"="Remal" \
      "com.remal.image.name"="${IMAGE_NAME}" \
      "com.remal.image.version"="${IMAGE_TAG}" \
      "com.remal.image.description"="${IMAGE_DESCRIPTION}" \
      "com.remal.image.author"="${IMAGE_AUTHOR}"


# fat image
FROM base AS base-fat


# slim image
FROM base AS base-slim


# final image
FROM base-$BUILD_TYPE AS final

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
