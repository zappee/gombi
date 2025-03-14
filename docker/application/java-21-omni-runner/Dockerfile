# ******************************************************************************
# Remal Java Executable JAR runner with Postgres database server image build
# file.
#
# Since:  March 2025
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
    IMAGE_DESCRIPTION="Ultimate Java-21 runner image for Spring Boot" \
    IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>"

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
    apk add --no-cache font-dejavu
