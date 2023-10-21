#!/bin/bash -ue
# ******************************************************************************
# Bash environment configuration in Docker environment.
#
# Since : May, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
source /shared.sh
log_start "$0"
cd "$EASYRSA_HOME"

echo "11111111"
sleep 10

# installing easy-rsa
printf "%s | [INFO ] initializing easy-rsa...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
./easyrsa init-pki

echo "2222222"
sleep 10

VARS="$EASYRSA_HOME/pki/vars"
cp pki/vars.example "$VARS"
{
  printf "set_var EASYRSA_REQ_CN \"%s\"\n" "$EASYRSA_REQ_CN"
  printf "set_var EASYRSA_REQ_COUNTRY \"%s\"\n" "$EASYRSA_REQ_COUNTRY"
  printf "set_var EASYRSA_REQ_PROVINCE \"%s\"\n" "$EASYRSA_REQ_PROVINCE"
  printf "set_var EASYRSA_REQ_CITY \"%s\"\n" "$EASYRSA_REQ_CITY"
  printf "set_var EASYRSA_REQ_ORG \"%s\"\n" "$EASYRSA_REQ_ORG"
  printf "set_var EASYRSA_REQ_EMAIL \"%s\"\n" "$EASYRSA_REQ_EMAIL"
  printf "set_var EASYRSA_REQ_OU \"%s\"\n" "$EASYRSA_REQ_OU"
  printf "set_var EASYRSA_ALGO \"%s\"\n" "$EASYRSA_ALGO"
  printf "set_var EASYRSA_DIGEST \"%s\"\n" "$EASYRSA_DIGEST"
  printf "set_var EASYRSA_KEY_SIZE \"%s\"\n" "$EASYRSA_KEY_SIZE"
} >> "$VARS"

echo "333333"
sleep 10

# generating the CA certificate
printf "%s | [INFO ] generating the root CA key and certificate...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
./easyrsa \
    --batch \
    --passin="pass:$EASYRSA_PASS" \
    --passout="pass:$EASYRSA_PASS" \
    build-ca

echo "4444444"
sleep 10

# generating a server certificate for this server
printf "%s | [INFO ] generating a server certificate request and key...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
./generate-cert.sh "$(hostname)"
log_end "$0"

echo "555555"
sleep 10
