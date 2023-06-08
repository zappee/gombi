# ******************************************************************************
#  Remal ForgeRock Access Management Docker image build file.
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

# build time variables
ARG AM_HOME="/opt/openam"

# environment variables
ENV IMAGE_NAME="am-7.3" \
    IMAGE_TAG="0.0.1-remal" \
    IMAGE_DESCRIPTION="Remal ForgeRock Access Management Server 7.3.0" \
    IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>" \
    \
    AM_HOME="$AM_HOME" \
    AM_INSTALL_KIT="AM-7.3.0.war" \
    CA_HOST="ca.remal.com" \
    LDAP_HOST="ds.remal.com" \
    LDAP_PORT=636 \
    LDAP_USER_DN="uid=admin" \
    LDAP_USER_PASSWORD="password" \
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
COPY "bin/$AM_INSTALL_KIT" "$CATALINA_HOME/webapps/openam/openam.war"
RUN set -ux; \
    cd "$CATALINA_HOME/webapps/openam"; \
    echo $(pwd); \
    ls -all; \
    jar -xvf "openam.war"; \
    rm "$CATALINA_HOME/webapps/openam/openam.war"


# slim image
FROM base AS base-slim
RUN set -ux; \
    hostIp="$(ip route | awk '/default/ { print $3 }')"; \
    mkdir -p "$CATALINA_HOME/webapps/openam"; \
    wget -O "$CATALINA_HOME/webapps/openam/openam.war" http://$hostIp:8080/docker-build/$AM_INSTALL_KIT; \
    cd "$CATALINA_HOME/webapps/openam"; \
    jar -xvf "openam.war"; \
    rm "$CATALINA_HOME/webapps/openam/openam.war"


# final image
FROM base-$BUILD_TYPE AS final
