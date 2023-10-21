# ******************************************************************************
# Remal Apache Tomcat Docker image build file.
#
# Since : January, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
ARG IMAGE_FROM=${IMAGE_FROM}
ARG BUILD_TYPE="fat"
FROM ${IMAGE_FROM} AS base

EXPOSE 22/tcp
EXPOSE 1331/tcp
EXPOSE 8080/tcp

# environment variables
ENV IMAGE_NAME="tomcat-9" \
    IMAGE_TAG="0.0.1-remal" \
    IMAGE_DESCRIPTION="Apache Tomcat 9 Docker image" \
    IMAGE_AUTHOR="Arnold Somogyi <arnold.somogyi@gmail.com>" \
    \
    CATALINA_HOME="/opt/tomcat" \
    CATALINA_USER="admin" \
    CATALINA_PASSWORD="password" \
    TOMCAT_INSTALL_KIT="apache-tomcat-9.0.71.tar.gz" \
    JAVA_OPTIONS="-Xms512m \
                  -Xmx1024m \
                  -XX:+UseParallelGC \
                  -Djava.util.logging.config.file=/opt/tomcat/conf/logging.properties"

# set image metadata
LABEL "com.remal.image.vendor"="Remal" \
      "com.remal.image.name"="${IMAGE_NAME}" \
      "com.remal.image.version"="${IMAGE_TAG}" \
      "com.remal.image.description"="${IMAGE_DESCRIPTION}" \
      "com.remal.image.author"="${IMAGE_AUTHOR}"


# fat image
FROM base AS base-fat
COPY "bin/$TOMCAT_INSTALL_KIT" "/tmp/"
RUN set -uxe; \
    printf "building fat image\n"; \
    mkdir -p "$CATALINA_HOME"; \
    tar -xvf "/tmp/$TOMCAT_INSTALL_KIT" --strip-components=1 -C "$CATALINA_HOME"; \
    rm -f "/tmp/$TOMCAT_INSTALL_KIT"


# slim image
FROM base AS base-slim
RUN set -uxe; \
    printf "building slim image\n"; \
    hostIp="$(ip route | awk '/default/ { print $3 }')"; \
    wget -O "/tmp/$TOMCAT_INSTALL_KIT" http://$hostIp:8080/docker-build/$TOMCAT_INSTALL_KIT; \
    mkdir -p "$CATALINA_HOME"; \
    tar -xvf "/tmp/$TOMCAT_INSTALL_KIT" --strip-components=1 -C "$CATALINA_HOME"; \
    rm -R "$CATALINA_HOME/webapps/docs/"; \
    rm -R "$CATALINA_HOME/webapps/examples/"; \
    rm -f "/tmp/$TOMCAT_INSTALL_KIT"


# final image
FROM base-$BUILD_TYPE AS final
RUN set -uxe; \
    printf "configuring the JVM...\n"; \
    printf "JAVA_OPTS=\"%s\"\n" "$JAVA_OPTIONS" > "$CATALINA_HOME/bin/setenv.sh"; \
    chmod +x "$CATALINA_HOME/bin/setenv.sh"; \
    \
    printf "installing XMLStarlet...\n"; \
    apk add --no-cache xmlstarlet; \
    \
    printf "installing native resources optional component for Apache Tomcat...\n"; \
    apk add --no-cache --upgrade tomcat-native; \
    \
    printf "configuring tomcat log to track access to resources...\n"; \
    xmlstarlet edit \
        --update "/Server/Service[@name='Catalina']/Engine[@name='Catalina']/Host[@name='localhost']/Valve[@className='org.apache.catalina.valves.AccessLogValve']/@pattern" -v "%t, %h, %u, &quot;%r&quot;, %s, %b, &quot;%{Referer}i&quot;, &quot;%{User-Agent}i&quot;, %D, %F" \
        "$CATALINA_HOME/conf/server.xml" | \
    xmlstarlet unesc > "$CATALINA_HOME/conf/server.xml.new"; \
    mv $CATALINA_HOME/conf/server.xml.new $CATALINA_HOME/conf/server.xml; \
    \
    printf "adding new tomcat user and role entries...\n"; \
    xmlstarlet edit \
        --inplace \
        -N "s=http://tomcat.apache.org/xml" \
        -s "/s:tomcat-users" -t elem -n "role" -s "/s:tomcat-users/role" -t attr -n "rolename" -v "manager-gui" \
        -s "/s:tomcat-users" -t elem -n "role" -s "/s:tomcat-users/role[last()]" -t attr -n "rolename" -v "admin-gui" \
        -s "/s:tomcat-users" -t elem -n "user" -s "/s:tomcat-users/user" -t attr -n "username" -v "$CATALINA_USER" \
        -s "/s:tomcat-users/user[@username='$CATALINA_USER']" -t attr -n "password" -v "$CATALINA_PASSWORD" \
        -s "/s:tomcat-users/user[@username='$CATALINA_USER']" -t attr -n "roles" -v "manager-gui,admin-gui" \
        "$CATALINA_HOME/conf/tomcat-users.xml"; \
    \
   printf "updating the access right of 'host-manager' webapp...\n"; \
   xmlstarlet edit \
        --inplace \
        --update "/Context/Valve[@className='org.apache.catalina.valves.RemoteAddrValve']/@allow" -v "\d+\.\d+\.\d+\.\d+" \
        "$CATALINA_HOME/webapps/host-manager/META-INF/context.xml"; \
    \
   printf "updating the access right of 'manager' webapp...\n"; \
   xmlstarlet edit \
        --inplace \
        --update "/Context/Valve[@className='org.apache.catalina.valves.RemoteAddrValve']/@allow" -v "\d+\.\d+\.\d+\.\d+" \
        "$CATALINA_HOME/webapps/manager/META-INF/context.xml"; \
   \
   printf "setting up environment variables...\n"; \
   printf "export %s=\"%s\"\n" "CATALINA_HOME" "$CATALINA_HOME" >> /etc/profile

COPY container-scripts/tomcat-functions.sh /
ONBUILD COPY container-scripts/init/* /docker.init/
ONBUILD COPY container-scripts/startup/* /docker.startup/
