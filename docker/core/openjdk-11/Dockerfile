# ******************************************************************************
# Remal OpenJDK 11 Docker image build file.
#
# Since:  January 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
# default build-time values, can be overwritten during the build
ARG IMAGE_FROM="remal-base:0.0.1"

FROM ${IMAGE_FROM}

EXPOSE 22/tcp
EXPOSE 1331/tcp

# defaultvalue of the scope level build-time variables
ARG IMAGE_NAME="remal-openjdk-11"
ARG IMAGE_TAG="0.0.1"
ARG IMAGE_DESCRIPTION="OpenJDK 11 Docker image"
ARG IMAGE_VENDOR="Remal"
ARG IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>"

ENV IMAGE_NAME="${IMAGE_NAME}" \
    IMAGE_TAG="${IMAGE_TAG}" \
    IMAGE_DESCRIPTION="${IMAGE_DESCRIPTION}" \
    IMAGE_VENDOR="${IMAGE_VENDOR}" \
    IMAGE_AUTHOR="${IMAGE_AUTHOR}" \
    \
   JAVA_HOME="/usr/lib/jvm/java-11-openjdk"

LABEL "image.name"="${IMAGE_NAME}" \
      "image.version"="${IMAGE_TAG}" \
      "image.description"="${IMAGE_DESCRIPTION}" \
      "image.vendor"="${IMAGE_VENDOR}" \
      "image.author"="${IMAGE_AUTHOR}"

# install openssl and openjdk
RUN set -ue; \
    apk add --no-cache openssl; \
	apk add --no-cache java-cacerts openjdk11-jdk; \
	java -version; \
	javac -version; \
    printf "export %s=\"%s\"\n" "JAVA_HOME" "$JAVA_HOME" >> /etc/profile

ONBUILD COPY container-scripts/init/* /docker.init/
ONBUILD COPY container-scripts/startup/* /docker.startup/
