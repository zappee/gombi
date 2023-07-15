# ******************************************************************************
# Remal ForgeRock Access Management Docker image build file.
#
#  Since : January, 2023
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
ARG IMAGE_FROM=${IMAGE_FROM}
ARG BUILD_TYPE="fat"
FROM ${IMAGE_FROM} AS base

EXPOSE 22/tcp
EXPOSE 443/tcp
EXPOSE 8080/tcp
EXPOSE 1331/tcp

# environment variables
ENV IMAGE_NAME="am-7.3" \
    IMAGE_TAG="0.0.1-remal" \
    IMAGE_DESCRIPTION="Remal ForgeRock Access Management Server 7.3.0" \
    IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>" \
    \
    CA_HOST="ca.remal.com" \
    \
    AM_INSTALL_KIT="AM-7.3.0.war" \
    AM_CONFIG_TOOL_INSTALL_KIT="AM-SSOConfiguratorTools-5.1.3.18.zip" \
    AM_CONFIG_TOOL="openam-configurator-tool-14.1.3.18.jar" \
    AM_CONFIG_TOOL_HOME="/home/openam/tools/config" \
    AM_HOME="/home/openam" \
    AM_CONTEXT_ROOT="openam" \
    AM_ADMIN_PASSWORD="password" \
    AM_DEFAULT_POLICY_AGENT_PASSWORD="password" \
    AM_CONFIG_STORE_HOST="ds.hello.com" \
    AM_CONFIG_STORE_PORT="636" \
    AM_CONFIG_STORE_MANAGER_PASSWD="password" \
    AM_USER_STORE_HOST="ds.hello.com" \
    AM_USER_STORE_PORT="636" \
    AM_USER_STORE_MANAGER_PASSWD="password" \
    \
    CATALINA_OPTS="\
        $CATALINA_OPTS \
        -Djavax.net.ssl.trustStore=/tmp/am.hello.com.p12 \
        -Djavax.net.ssl.trustStorePassword=changeit \
        -Djavax.net.ssl.trustStoreType=PKCS12 \
        -Xms1024m \
        -Xmx1024m \
        -XX:+UseParallelGC \
        -XX:MetaspaceSize=256m \
        -XX:MaxMetaspaceSize=256m"

# set image metadata
LABEL "com.remal.image.vendor"="Remal" \
      "com.remal.image.name"="${IMAGE_NAME}" \
      "com.remal.image.version"="${IMAGE_TAG}" \
      "com.remal.image.description"="${IMAGE_DESCRIPTION}" \
      "com.remal.image.author"="${IMAGE_AUTHOR}"


# fat image
FROM base AS base-fat
COPY "bin/$AM_INSTALL_KIT" "$CATALINA_HOME/webapps/openam/$AM_CONTEXT_ROOT.war"
COPY "bin/$AM_CONFIG_TOOL_INSTALL_KIT" "$AM_CONFIG_TOOL_HOME/"
RUN set -ux; \
    cd "$CATALINA_HOME/webapps/$AM_CONTEXT_ROOT"; \
    jar -xvf "$AM_CONTEXT_ROOT.war"; \
    rm "$CATALINA_HOME/webapps/openam/$AM_CONTEXT_ROOT.war"; \
    \
    cd "$AM_CONFIG_TOOL_HOME"; \
    unzip "$AM_CONFIG_TOOL_INSTALL_KIT"; \
    rm "$AM_CONFIG_TOOL_INSTALL_KIT"


# slim image
FROM base AS base-slim
RUN set -ux; \
    hostIp="$(ip route | awk '/default/ { print $3 }')"; \
    mkdir -p "$CATALINA_HOME/webapps/$AM_CONTEXT_ROOT"; \
    wget -O "$CATALINA_HOME/webapps/openam/$AM_CONTEXT_ROOT.war" http://$hostIp:8080/docker-build/$AM_INSTALL_KIT; \
    cd "$CATALINA_HOME/webapps/$AM_CONTEXT_ROOT"; \
    jar -xvf "$AM_CONTEXT_ROOT.war"; \
    rm "$CATALINA_HOME/webapps/openam/$AM_CONTEXT_ROOT.war"; \
    \
    mkdir -p "$AM_CONFIG_TOOL_HOME"; \
    wget -O "$AM_CONFIG_TOOL_HOME/$AM_CONFIG_TOOL_INSTALL_KIT" http://$hostIp:8080/docker-build/$AM_CONFIG_TOOL_INSTALL_KIT; \
    cd "$AM_CONFIG_TOOL_HOME"; \
    unzip "$AM_CONFIG_TOOL_INSTALL_KIT"; \
    rm "$AM_CONFIG_TOOL_INSTALL_KIT"


# final image
FROM base-$BUILD_TYPE AS final
