/*
 * Vault configuration. See: https://www.vaultproject.io/docs/configuration
 */

storage "file" {
        path = "${VAULT_FILE_STORE}"
}

listener "tcp" {
  address            = "${LISTENING_HOST}:${API_PORT}"
  tls_disable        = false
  tls_cert_file      = "${SERVER_CERT_FILE}"
  tls_key_file       = "${SERVER_KEY_FILE}"
  tls_client_ca_file = "${CA_CERT_FILE}"
}

api_addr      = "https://${LISTENING_HOST}:${API_PORT}"
disable_mlock = true
ui            = true
log_level     = "${LOG_LEVEL}"
