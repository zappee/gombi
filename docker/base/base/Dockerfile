# ******************************************************************************
# Remal Base Docker image build file.
#
# Since:  May 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
# default build-time values, can be overwritten during the build
ARG IMAGE_FROM="alpine:3.19.1"

FROM ${IMAGE_FROM}

EXPOSE 22/tcp
EXPOSE 1331/tcp

# defaultvalue of the scope level build-time variables
ARG IMAGE_NAME="remal-base"
ARG IMAGE_TAG="0.0.1"
ARG IMAGE_DESCRIPTION="Remal Base Docker image"
ARG IMAGE_VENDOR="Remal"
ARG IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>"

# environment variables
ENV IMAGE_NAME="${IMAGE_NAME}" \
    IMAGE_TAG="${IMAGE_TAG}" \
    IMAGE_DESCRIPTION="${IMAGE_DESCRIPTION}" \
    IMAGE_VENDOR="${IMAGE_VENDOR}" \
    IMAGE_AUTHOR="${IMAGE_AUTHOR}" \
    \
    SSH_USER="root" \
    SSH_PASSWORD="password" \
    UP_SIGNAL_PORT=1331

# set image metadata
LABEL "image.name"="${IMAGE_NAME}" \
      "image.version"="${IMAGE_TAG}" \
      "image.description"="${IMAGE_DESCRIPTION}" \
      "image.vendor"="${IMAGE_VENDOR}" \
      "image.author"="${IMAGE_AUTHOR}"

# installing tools and settin up bash as a default shell
RUN set -ue; \
    apk add --no-cache socat; \
    apk add --no-cache bash; \
    apk add --no-cache bash coreutils; \
    sed -i 's|/bin/ash|/bin/bash|' /etc/passwd; \
    printf "%s\n" "source ~/.bashrc" >> ~/.profile; \
    printf "%s\n\n" "Welcome to Remal docker container!" > /etc/motd

# installing and configuring ssh-server that will listen on port 22
RUN set -ue; \
    apk add --no-cache sshpass; \
    apk add --no-cache openssh; \
    printf "PasswordAuthentication yes\n" >> /etc/ssh/sshd_config; \
    printf "PermitRootLogin yes\n" >> /etc/ssh/sshd_config; \
    printf "%s:%s" "$SSH_USER" "$SSH_PASSWORD" | chpasswd; \
    ssh-keygen -A

# configuring first-boot and startup script executors
RUN set -ue; \
    mkdir /docker.init; \
    mkdir /docker.startup

COPY container-scripts/init/* /docker.init/
COPY container-scripts/startup/* /docker.startup/
ONBUILD COPY container-scripts/init/* /docker.init/
ONBUILD COPY container-scripts/startup/* /docker.startup/

COPY container-scripts/entrypoint.sh container-scripts/shared.sh /
ENTRYPOINT ["/entrypoint.sh"]
