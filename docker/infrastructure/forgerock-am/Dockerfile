# ******************************************************************************
# Remal ForgeRock Access Management Docker image build file.
#
# Since: January 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
# default build-time values, can be overwritten during the build
ARG IMAGE_FROM="remal-tomcat-9:0.0.1"
ARG BUILD_TYPE="fat"

FROM ${IMAGE_FROM} AS base

EXPOSE 22/tcp
EXPOSE 443/tcp
EXPOSE 8080/tcp
EXPOSE 1331/tcp

# defaultvalue of the scope level build-time variables
ARG IMAGE_NAME="remal-am-7.3"
ARG IMAGE_TAG="0.0.1"
ARG IMAGE_DESCRIPTION="ForgeRock Directory Server 7.3.0"
ARG IMAGE_VENDOR="Remal"
ARG IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>"

# environment variables
ENV IMAGE_NAME="${IMAGE_NAME}" \
    IMAGE_TAG="${IMAGE_TAG}" \
    IMAGE_DESCRIPTION="${IMAGE_DESCRIPTION}" \
    IMAGE_VENDOR="${IMAGE_VENDOR}" \
    IMAGE_AUTHOR="${IMAGE_AUTHOR}" \
    \
    PKI_HOST="pki.remal.com" \
    \
    AM_CONFIG_BACKUP="true" \
    AM_CONFIG_RESTORE_FROM="latest" \
    \
    AM_INSTALL_KIT="AM-7.3.0.war" \
    AM_CONFIG_TOOL_INSTALL_KIT="AM-SSOConfiguratorTools-5.1.3.18.zip" \
    AM_CONFIG_TOOL="openam-configurator-tool-14.1.3.18.jar" \
    AM_CONFIG_TOOL_HOME="/home/openam/tools/config" \
    AM_HOME="/opt/openam" \
    AM_CONTEXT_ROOT="openam" \
    AM_ADMIN_PASSWORD="password" \
    AM_DEFAULT_POLICY_AGENT_PASSWORD="password" \
    AM_CONFIG_STORE_HOST="ds.hello.com" \
    AM_CONFIG_STORE_PORT="636" \
    AM_CONFIG_STORE_MANAGER_PASSWORD="password" \
    AM_USER_STORE_HOST="ds.hello.com" \
    AM_USER_STORE_PORT="636" \
    AM_USER_STORE_MANAGER_PASSWORD="password"

LABEL "image.name"="${IMAGE_NAME}" \
      "image.version"="${IMAGE_TAG}" \
      "image.description"="${IMAGE_DESCRIPTION}" \
      "image.vendor"="${IMAGE_VENDOR}" \
      "image.author"="${IMAGE_AUTHOR}"


# fat image
FROM base AS base-fat
COPY "bin/$AM_INSTALL_KIT" "$CATALINA_HOME/webapps/openam/$AM_CONTEXT_ROOT.war"
COPY "bin/$AM_CONFIG_TOOL_INSTALL_KIT" "$AM_CONFIG_TOOL_HOME/"
RUN set -ue; \
    cd "$CATALINA_HOME/webapps/$AM_CONTEXT_ROOT"; \
    jar -xvf "$AM_CONTEXT_ROOT.war"; \
    rm "$CATALINA_HOME/webapps/openam/$AM_CONTEXT_ROOT.war"; \
    \
    cd "$AM_CONFIG_TOOL_HOME"; \
    unzip "$AM_CONFIG_TOOL_INSTALL_KIT"; \
    rm "$AM_CONFIG_TOOL_INSTALL_KIT"


# slim image
FROM base AS base-slim
RUN set -ue; \
    host_ip="$(ip route | awk '/default/ { print $3 }')"; \
    mkdir -p "$CATALINA_HOME/webapps/$AM_CONTEXT_ROOT"; \
    wget -O "$CATALINA_HOME/webapps/openam/$AM_CONTEXT_ROOT.war" http://$host_ip:8080/docker-build/$AM_INSTALL_KIT; \
    cd "$CATALINA_HOME/webapps/$AM_CONTEXT_ROOT"; \
    jar -xvf "$AM_CONTEXT_ROOT.war"; \
    rm "$CATALINA_HOME/webapps/openam/$AM_CONTEXT_ROOT.war"; \
    \
    mkdir -p "$AM_CONFIG_TOOL_HOME"; \
    wget -O "$AM_CONFIG_TOOL_HOME/$AM_CONFIG_TOOL_INSTALL_KIT" http://$host_ip:8080/docker-build/$AM_CONFIG_TOOL_INSTALL_KIT; \
    cd "$AM_CONFIG_TOOL_HOME"; \
    unzip "$AM_CONFIG_TOOL_INSTALL_KIT"; \
    rm "$AM_CONFIG_TOOL_INSTALL_KIT"


# final image
FROM base-${BUILD_TYPE}
COPY container-scripts/shutdown-actions.sh /
