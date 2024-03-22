# ******************************************************************************
# Remal OpenJDK 21 Docker image build file.
#
# Since : March 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
ARG IMAGE_FROM=${IMAGE_FROM}
FROM ${IMAGE_FROM}

EXPOSE 22/tcp
EXPOSE 1331/tcp

# environment variables
ENV IMAGE_NAME="openjdk-21" \
    IMAGE_TAG="0.0.1-remal" \
    IMAGE_DESCRIPTION="Remal Base image" \
    IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>" \
    \
    JAVA_HOME="/usr/lib/jvm/java-21-openjdk"

# set image metadata
LABEL "com.remal.image.vendor"="Remal" \
      "com.remal.image.name"="${IMAGE_NAME}" \
      "com.remal.image.version"="${IMAGE_TAG}" \
      "com.remal.image.description"="${IMAGE_DESCRIPTION}" \
      "com.remal.image.author"="${IMAGE_AUTHOR}"

# install openssl and openjdk
RUN set -ue; \
    apk add --no-cache openssl; \
	apk add --no-cache java-cacerts openjdk21-jdk; \
	java -version; \
	javac -version; \
    printf "export %s=\"%s\"\n" "JAVA_HOME" "$JAVA_HOME" >> /etc/profile

ONBUILD COPY container-scripts/init/* /docker.init/
ONBUILD COPY container-scripts/startup/* /docker.startup/
