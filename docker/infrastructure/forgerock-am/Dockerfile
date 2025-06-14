# ******************************************************************************
# Remal ForgeRock Access Management Docker image build file.
#
#  Since:  January 2023
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
ARG IMAGE_FROM="unknown"
ARG BUILD_TYPE="fat"
FROM ${IMAGE_FROM} AS base

EXPOSE 22/tcp
EXPOSE 443/tcp
EXPOSE 8080/tcp
EXPOSE 1331/tcp

ARG IMAGE_NAME="N/A"
ARG IMAGE_TAG="N/A"
ARG IMAGE_AUTHOR="N/A"
ARG IMAGE_DESCRIPTION="N/A"

# environment variables
ENV IMAGE_NAME="$IMAGE_NAME" \
    IMAGE_TAG="$IMAGE_TAG" \
    IMAGE_AUTHOR="$IMAGE_AUTHOR" \
    IMAGE_DESCRIPTION="$IMAGE_DESCRIPTION" \
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
    AM_CONFIG_STORE_MANAGER_PASSWD="password" \
    AM_USER_STORE_HOST="ds.hello.com" \
    AM_USER_STORE_PORT="636" \
    AM_USER_STORE_MANAGER_PASSWD="password"

# set image metadata
LABEL "com.remal.image.name"="$IMAGE_NAME" \
      "com.remal.image.tag"="$IMAGE_TAG" \
      "com.remal.image.author"="$IMAGE_AUTHOR" \
      "com.remal.image.description"="$IMAGE_DESCRIPTION" \
      "com.remal.image.vendor"="Remal"


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
FROM base-$BUILD_TYPE AS final
COPY container-scripts/shutdown-actions.sh /
