#!/bin/bash -ue
# ******************************************************************************
# Functions that helps to manage Postgres SQL database server.
#
# Since:  April 2024
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
. /shared.sh

# ------------------------------------------------------------------------------
# Create a new database and a new user. It can be used by the Java application
# running in the container.
#
# Arguments:
#    arg 1: database name
#    arg 2: username
#    arg 3: password for the user
# ------------------------------------------------------------------------------
function create_database_and_user() {
  local database user password
  database="$1"
  user="$2"
  password="$3"

  printf "%s | [INFO]  creating a new database and a user...\n" "$(date +"%Y-%m-%d %H:%M:%S")"
  printf "%s | [DEBUG]            database name: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$database"
  printf "%s | [DEBUG]                     user: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$user"
  printf "%s | [DEBUG]    password for the user: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$password"

  /bin/su -c "psql -c \"CREATE USER $user WITH PASSWORD '$password';\"" - postgres
  /bin/su -c "psql -c \"CREATE DATABASE $database OWNER $user;\"" - postgres
  /bin/su -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE $database TO $user;\"" - postgres
}

# ----------------------------------------------------------------------------
# Postgres server configuration.
# ------------------------------------------------------------------------------
function postgres_configuration() {
  printf "%s | [INFO]  configuring Postgres database server...\n" "$(date +"%Y-%m-%d %H:%M:%S")"
  printf "%s | [DEBUG]     POSTGRES_CONFIG: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$POSTGRES_CONFIG"
  printf "%s | [DEBUG]    POSTGRES_LOG_DIR: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$POSTGRES_LOG_DIR"

  sed -i "s|\${POSTGRES_LOG_DIR}|$POSTGRES_LOG_DIR|g" "$POSTGRES_CONFIG"
}

# ------------------------------------------------------------------------------
# Set the password for the given user.
#
# Arguments:
#    arg 1: username
#    arg 2: password for the user
# ------------------------------------------------------------------------------
function set_database_password() {
  local user password
  user="$1"
  password="$2"

  printf "%s | [INFO]  setting up the password for a database user...\n" "$(date +"%Y-%m-%d %H:%M:%S")"
  printf "%s | [DEBUG]        database user: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$user"
  printf "%s | [DEBUG]    database password: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$password"

  /bin/su -c "psql -c \"ALTER USER $user PASSWORD '$password';\"" - postgres
}

# ------------------------------------------------------------------------------
# Start the Postgres Database Server and wait for the full server start-up.
#
# Arguments
#    arg 1:  'true' to start the server
# ------------------------------------------------------------------------------
function start_postgres() {
  local signal
  signal="$1"

  if [ "$signal" == "true" ]; then
    local postgres_log
    postgres_log="$POSTGRES_LOG_DIR/postgresql.log"

    printf "%s | [INFO]  starting the Postgres database server...\n" "$(date +"%Y-%m-%d %H:%M:%S")"
    printf "%s | [DEBUG]     POSTGRES_DATA: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$POSTGRES_DATA"
    printf "%s | [DEBUG]    start postgres: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$signal"
    printf "%s | [DEBUG]      postgres_log: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$postgres_log"

    pkill -f "$postgres_log" || true # exit code must be zero always
    rm -f "$postgres_log"
    /bin/su -c "pg_ctl start -D $POSTGRES_DATA" - postgres
    tail -n +1 -F "$postgres_log" &

    wait_until_content_found "$postgres_log" "database system is ready"
    printf "%s | [INFO]  Postgres Database server has been started successfully\n" "$(date +"%Y-%m-%d %H:%M:%S")"
  else
    printf "%s | [DEBUG] skipping the startup of the Postgres database server...\n" "$(date +"%Y-%m-%d %H:%M:%S")"
    printf "%s | [DEBUG] to start the Postgres database server, use 'START_DB=true' in the 'docker-compose.yml' file\n" "$(date +"%Y-%m-%d %H:%M:%S")"
  fi
}

# ----------------------------------------------------------------------------
# Stop Postgres database server.
# ------------------------------------------------------------------------------
function stop_postgres() {
  local postgres_log
  postgres_log="$POSTGRES_LOG_DIR/postgresql.log"

  printf "%s | [INFO]  stopping the Postgres database server...\n" "$(date +"%Y-%m-%d %H:%M:%S")"
  printf "%s | [DEBUG]     POSTGRES_DATA: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$POSTGRES_DATA"
  printf "%s | [DEBUG]      postgres_log: \"%s\"\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$postgres_log"

  /bin/su -c "pg_ctl stop -D $POSTGRES_DATA" - postgres
  printf "%s | [INFO]  Postgres Database server has been stopped...\n" "$(date +"%Y-%m-%d %H:%M:%S")"
}
