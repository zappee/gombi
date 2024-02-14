#!/bin/bash
# ******************************************************************************
# Remal Server certificate generator.
#
# Since : March, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Usage: gen-server-cert.sh [hostname]
#    hostname: name of the host machine where the certificate will be used
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
. /shared.sh

# ------------------------------------------------------------------------------
# Validates the start arguments of this script.
# ------------------------------------------------------------------------------
function validate_arguments() {
  if [[ $# -gt 2 ]]; then
    printf "%s | [ERROR] Illegal number of parameters!\n" "$(date +"%Y-%b-%d %H:%M:%S")"
    printf "%s | [ERROR] Usage: %s hostname [san]\n\n" "$(date +"%Y-%b-%d %H:%M:%S")" "${0##*/}"
    exit 1
  fi
}

# ------------------------------------------------------------------------------
# Show the start arguments and the relevant environment values of this script.
# ------------------------------------------------------------------------------
function show_context() {
  printf "%s | [INFO ] generating a server certificate using easy-rsa...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  printf "%s | [INFO ] running \"%s\" script on \"%s\" machine...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "${0##*/}" "$(hostname -f)"
  printf "%s | [DEBUG]           EASYRSA_HOME: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$EASYRSA_HOME"
  printf "%s | [DEBUG]         EASYRSA_REQ_CN: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$EASYRSA_REQ_CN"
  printf "%s | [DEBUG]    EASYRSA_REQ_COUNTRY: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$EASYRSA_REQ_COUNTRY"
  printf "%s | [DEBUG]   EASYRSA_REQ_PROVINCE: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$EASYRSA_REQ_PROVINCE"
  printf "%s | [DEBUG]       EASYRSA_REQ_CITY: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$EASYRSA_REQ_CITY"
  printf "%s | [DEBUG]        EASYRSA_REQ_ORG: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$EASYRSA_REQ_ORG"
  printf "%s | [DEBUG]      EASYRSA_REQ_EMAIL: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$EASYRSA_REQ_EMAIL"
  printf "%s | [DEBUG]         EASYRSA_REQ_OU: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$EASYRSA_REQ_OU"
  printf "%s | [DEBUG]           EASYRSA_ALGO: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$EASYRSA_ALGO"
  printf "%s | [DEBUG]         EASYRSA_DIGEST: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$EASYRSA_DIGEST"
  printf "%s | [DEBUG]       EASYRSA_KEY_SIZE: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$EASYRSA_KEY_SIZE"
  printf "%s | [DEBUG]           EASYRSA_PASS: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$EASYRSA_PASS"
  printf "%s | [DEBUG] arguments of the \"%s\" script:\n" "$(date +"%Y-%b-%d %H:%M:%S")" "${0##*/}"
  printf "%s | [DEBUG]               hostname: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$1"
  printf "%s | [DEBUG]                    san: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "${2:-}"
}

# ------------------------------------------------------------------------------
# Step 1) Generates a server certificate request and a private key for the
# given host/domain.
# ------------------------------------------------------------------------------
function generate_cert_req_and_key() {
  local domain san work_dir
  domain="$1"
  san="${2:-}"
  work_dir=${PWD}

  printf "%s | [INFO ] generating a server certificate request and key...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  printf "%s | [DEBUG]    EASYRSA_HOME: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$EASYRSA_HOME"
  printf "%s | [DEBUG]    EASYRSA_PASS: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$EASYRSA_PASS"
  printf "%s | [DEBUG]          domain: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$domain"
  printf "%s | [DEBUG]             san: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$san"
  printf "%s | [DEBUG]        work_dir: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$work_dir"

  cd "$EASYRSA_HOME" || { println "invalid path: %s" "$EASYRSA_HOME"; exit 1; }

  if [[ -z "${san-}"  ]]; then
    printf "%s | [DEBUG] server certificate request without SAN\n" "$(date +"%Y-%b-%d %H:%M:%S")"
    ./easyrsa \
      --batch \
      --passout="pass:$EASYRSA_PASS" \
      --req-cn="$domain" \
      gen-req "$domain"
  else
    printf "%s | [DEBUG] server certificate request with SAN: %s\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$san"
    ./easyrsa \
      --batch \
      --passout="pass:$EASYRSA_PASS" \
      --req-cn="$domain" \
      --subject-alt-name="$san" \
      gen-req "$domain"
  fi

  cd "$work_dir" || { println "invalid path: %s" "$work_dir"; exit 1; }
}

# ------------------------------------------------------------------------------
# Step 2) Signs the server certificate request.
# ------------------------------------------------------------------------------
function signing_cert_req() {
  local domain work_dir
  domain="$1"
  work_dir=${PWD}

  printf "%s | [INFO ] signing the server certificate request...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  cd "$EASYRSA_HOME" || { println "invalid path: %s" "$EASYRSA_HOME"; exit 1; }
  ./easyrsa \
    --batch \
    --passin="pass:$EASYRSA_PASS" \
    sign-req \
    serverClient \
    "$domain"
  cd "$work_dir" || { println "invalid path: %s" "$work_dir"; exit 1; }
}

# ------------------------------------------------------------------------------
# Create a new PKCS#12 keystore and import the server certificate into it.
# ------------------------------------------------------------------------------
function export_to_keystore() {
  local domain
  domain="$1"

  printf "%s | [INFO ] creating a new PKCS#12 keystore and import the \"%s\" certificate into it...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$domain"
  cd "$EASYRSA_HOME" || { println "invalid path: %s" "$EASYRSA_HOME"; exit 1; }
  ./easyrsa \
    --passin="pass:$EASYRSA_PASS" \
    --passout="pass:$EASYRSA_PASS" \
    export-p12 "$domain" usefn
  cd "$work_dir" || { println "invalid path: %s" "$work_dir"; exit 1; }
}

# ------------------------------------------------------------------------------
# Main program starts here.
# ------------------------------------------------------------------------------
validate_arguments "$@"
show_context "$@"
generate_cert_req_and_key "$@"
signing_cert_req "$1"
export_to_keystore "$1"
import_to_keystore "ca-cert" "$EASYRSA_HOME/pki/ca.crt" "$EASYRSA_HOME/pki/private/$1.p12" "$EASYRSA_PASS"
