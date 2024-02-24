#!/bin/bash -ue
# ******************************************************************************
# Remal 3rd party file copier.
#
# The install binary files are big so we keep them out of the source code
# repository. In the Git repo we only keep zero length marker files using the
# original file name. This script overwrites the zero length marker files.
#
# Before the usage the REMAL_BINARY_HOME and PROJECT_HOME variables must be set
# properly.
#
# Since : February, 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
REMAL_BINARY_HOME="$HOME/dev/applications/apache-tomcat/webapps/docker-build/"
PROJECT_HOME="$HOME/dev/workspace/java/remal/gombi"

FORGEROCK_DS="DS-7.3.0.zip"
FORGEROCK_AM="AM-7.3.0.war"
FORGEROCK_AM_SSO_CONFIGURATOR="AM-SSOConfiguratorTools-5.1.3.18.zip"
APACHE_TOMCAT="apache-tomcat-9.0.71.tar.gz"
OPENVPN_EASYRSA="EasyRSA-3.1.7.tgz"
HASHICORP_CONSUL="consul_1.17.3_linux_386.zip"
HASHICORP_VAULT="vault_1.15.0_linux_386.zip"

# ------------------------------------------------------------------------------
# Main program starts here.
# ------------------------------------------------------------------------------
printf "The install binary files are big so we keep them out of the source code\n"
printf "repository. In the Git repo we only keep zero length marker files using\n"
printf "the original file name. This script overwrites the zero length marker\n"
printf "files.\n\n"

read -n1 -r -p $'Are you sure you want to continue? [y/n] ' key
printf "\n"
if [[ ! $key =~ ^[Yy]$ ]]; then
  exit 1
fi

printf "1) copying %s to the docker project directory...\n" "$FORGEROCK_DS"
cp "$REMAL_BINARY_HOME/$FORGEROCK_DS" "$PROJECT_HOME/docker/infrastructure/forgerock-ds/bin/"

printf "2) copying %s to the docker project directory...\n" "$FORGEROCK_AM"
cp "$REMAL_BINARY_HOME/$FORGEROCK_AM" "$PROJECT_HOME/docker/infrastructure/forgerock-am/bin/"

printf "3) copying %s to the docker project directory...\n" "$FORGEROCK_AM_SSO_CONFIGURATOR"
cp "$REMAL_BINARY_HOME/$FORGEROCK_AM_SSO_CONFIGURATOR" "$PROJECT_HOME/docker/infrastructure/forgerock-am/bin/"

printf "4) copying %s to the docker project directory...\n" "$APACHE_TOMCAT"
cp "$REMAL_BINARY_HOME/$APACHE_TOMCAT" "$PROJECT_HOME/docker/infrastructure/tomcat-9/bin/"

printf "5) copying %s to the docker project directory...\n" "$OPENVPN_EASYRSA"
cp "$REMAL_BINARY_HOME/$OPENVPN_EASYRSA" "$PROJECT_HOME/docker/infrastructure/easy-rsa-pki/bin/"

printf "6) copying %s to the docker project directory...\n" "$HASHICORP_CONSUL"
cp "$REMAL_BINARY_HOME/$HASHICORP_CONSUL" "$PROJECT_HOME/docker/infrastructure/hcp-consul/bin/"

printf "7) copying %s to the docker project directory...\n" "$HASHICORP_VAULT"
cp "$REMAL_BINARY_HOME/$HASHICORP_VAULT" "$PROJECT_HOME/docker/infrastructure/hcp-vault/bin/"
