#!/bin/bash -ue
# ******************************************************************************
# Functions that helps to manage HashiCorp Consul.
#
# Since : October, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
. /shared.sh

# ----------------------------------------------------------------------------
# Start HashiCorp Consul.
# ------------------------------------------------------------------------------
function start_consul() {
  local template_config_file config_file
  template_config_file="$CONSUL_CONFIG_TEMPLATE_DIR/consul-template.json"
  config_file="$CONSUL_CONFIG_DIR/consul.json"

  printf "%s | [INFO]  starting HashiCorp Consul...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  printf "%s | [DEBUG]    consul data directory:   \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$CONSUL_DATA_DIR"
  printf "%s | [DEBUG]    consul config directory: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$CONSUL_CONFIG_DIR"
  printf "%s | [DEBUG]    consul node name:        \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$CONSUL_NODE_NAME"
  printf "%s | [DEBUG]    consul config template:  \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$template_config_file"
  printf "%s | [DEBUG]    consul config file:      \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$config_file"
  printf "%s | [DEBUG]    keystore home:           \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$KEYSTORE_HOME"

  mkdir -p "$CONSUL_CONFIG_DIR"
  cp -f "$template_config_file" "$config_file"
  sed -i "s|\${CONSUL_DATA_DIR}|$CONSUL_DATA_DIR|g" "$config_file"
  sed -i "s|\${CONSUL_NODE_NAME}|$CONSUL_NODE_NAME|g" "$config_file"
  sed -i "s|\${KEYSTORE_HOME}|$KEYSTORE_HOME|g" "$config_file"

  #consul agent -config-dir "$CONSUL_CONFIG_DIR"
  # result:
  # ==> Failed to load cert/key pair: tls: failed to parse private key

  # consul \
  #   agent \
  #   -server \
  #   -ui \
  #   -bootstrap \
  ####   -advertise=127.0.0.1 \
  #   -bind=127.0.0.1 \
  #   -node="$CONSUL_NODE_NAME" \
  #   -config-dir="$CONSUL_CONFIG_DIR" \
  #   -data-dir="$CONSUL_DATA_DIR" \
  #   &

  # openssl pkey -in consul.remal.com.key -out plain.key


#2024-Feb-01 17:09:21 | [INFO]  decrypting private key...
#2024-Feb-01 17:09:21 | [DEBUG]        SSH_USER: "root"
#2024-Feb-01 17:09:21 | [DEBUG]    SSH_PASSWORD: "password"
#2024-Feb-01 17:09:21 | [DEBUG]        PKI_HOST: "pki.hello.com"
#2024-Feb-01 17:09:21 | [DEBUG]       host_name: "consul.hello.com"
#Enter pass phrase for /opt/easy-rsa/pki/private/consul.hello.com.key:
#Enter pass phrase for /opt/easy-rsa/pki/private/consul.hello.com.key:
#Enter pass phrase for /opt/easy-rsa/pki/private/consul.hello.com.key:
#Could not read key from /opt/easy-rsa/pki/private/consul.hello.com.key
#483B5A07B57F0000:error:1608010C:STORE routines:ossl_store_handle_load_result:unsupported:crypto/store/store_result.c:151:
#483B5A07B57F0000:error:1400006B:UI routines:UI_process:processing error:crypto/ui/ui_lib.c:548:while reading strings
#483B5A07B57F0000:error:07880028:common libcrypto routines:do_ui_passphrase:UI lib:crypto/passphrase.c:187:
#483B5A07B57F0000:error:1C80009F:Provider routines:epki2pki_decode:unable to get passphrase:providers/implementations/encode_decode/decode_epki2pki.c:96:
#run-parts: /docker.init/30602_generate-server-cert.sh: exit status 1


# config file
#   "enable_syslog": true,

  while [ "$(consul members 2>/dev/null | awk "/$CONSUL_NODE_NAME/ && /alive/" | wc -l)" -ne 1 ]; do
    echo "consul is not running, waiting..."
    sleep 0.5
  done

  printf "%s | [INFO]  HashiCorp Consul has been started\n" "$(date +"%Y-%b-%d %H:%M:%S")"
}
