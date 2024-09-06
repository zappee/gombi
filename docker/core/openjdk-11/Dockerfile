# ******************************************************************************
# Remal OpenJDK 11 Docker image build file.
#
# Since : January, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
ARG IMAGE_FROM
ARG BUILD_TYPE
FROM ${IMAGE_FROM:-remal-base:0.0.1}

EXPOSE 22/tcp
EXPOSE 1331/tcp

# build-time variables
ARG IMAGE_NAME
ARG IMAGE_TAG
ARG IMAGE_DESCRIPTION

# environment variables
ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk"

# set image metadata
LABEL "com.remal.image.name"="${IMAGE_NAME}" \
      "com.remal.image.version"="${IMAGE_TAG}" \
      "com.remal.image.description"="${IMAGE_DESCRIPTION}" \
      "com.remal.image.vendor"="Remal" \
      "com.remal.image.author"="Arnold Somogyi <arnold.somogyi@gmail.com>"

# install openssl and openjdk
RUN set -ue; \
    apk add --no-cache openssl; \
	apk add --no-cache java-cacerts openjdk11-jdk; \
	java -version; \
	javac -version; \
    printf "export %s=\"%s\"\n" "JAVA_HOME" "$JAVA_HOME" >> /etc/profile

ONBUILD COPY container-scripts/init/* /docker.init/
ONBUILD COPY container-scripts/startup/* /docker.startup/
