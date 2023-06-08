#!/bin/bash
# ******************************************************************************
#  Remal Docker entrypoint file.
#
#  Since : January, 2023
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************

# ------------------------------------------------------------------------------
# Waiting for the LDAP server to be up and ready to serve requests
# ------------------------------------------------------------------------------
waitForLdapServer() {
  printf "[DEBUG] checking the state of the LDAP server running on %s machine...\n" "$LDAP_HOST"
  while ! nc -z "$LDAP_HOST" "$LDAP_SIGNAL_PORT"; do
    sleep 0.5
  done
  printf "[INFO]  LDAP server is up and running on %s\n" "$LDAP_HOST"
}

# ------------------------------------------------------------------------------
# It blocks the execution and wait until the LDAP server is up and running.
# ------------------------------------------------------------------------------
function importCertificate() {
  printf "[INFO]  importing the OpenDJ self-signed certificate...\n"

  local certificate storePassword
  certificate=/tmp/ca-cert.cer
  storePassword=changeit

  local ldapUser ldapPassword ldapUri
  ldapUser=$(cut -d ":" -f 1 <<< "$LDAP_SSH_CREDENTIALS")
  ldapPassword=$(cut -d ":" -f 2 <<< "$LDAP_SSH_CREDENTIALS")
  ldapUri="$ldapUser@$LDAP_HOST"

  printf "[DEBUG] > downloading the ca-certificate from '%s:%s' using '%s' as the password...\n" \
      "$ldapUri" \
      "$certificate" \
      "$ldapPassword"
  sshpass -p "$ldapPassword" scp \
      -o StrictHostKeyChecking=no \
      -o ConnectTimeout=10 \
      -o ConnectionAttempts=5 \
      "$ldapUri:$certificate" /tmp/

  printf "[DEBUG] > importing the ca-certificate to keystore...\n"
  keytool \
      -import \
      -v \
      -trustcacerts \
      -alias "ca-cert" \
      -keystore $CATALINA_HOME/conf/remal.com.pkcs12 \
      -keypass $storePassword \
      -storepass $storePassword \
      -noprompt \
      -file $certificate
}

# ------------------------------------------------------------------------------
# Main program starts here.
# ------------------------------------------------------------------------------
waitForLdapServer
importCertificate
