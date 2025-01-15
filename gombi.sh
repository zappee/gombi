#!/bin/bash -ue
# ******************************************************************************
# Remal Docker Image build file.
#
# Usage:
#    1) Set the REMAL_HOME environment variable.
#       It must point to the project directory. If the variable is not set then
#       the current directory is used as a home directory.
#       Example: export REMAL_HOME="$HOME/Java/gombi"
#
#   2) Run the script using ./remal.sh
#
# Since : January 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
WORKSPACE="${REMAL_HOME:-$(pwd)}"
BUILD_TYPE="slim"
ENVIRONMENT_FILE=".env.hello.com"
COMMAND="${1:-}"

LABEL_BASE="Base;base/base"
LABEL_JAVA_11="OpenJDK 11;core/openjdk-11"
LABEL_JAVA_17="OpenJDK 17;core/openjdk-17"
LABEL_JAVA_21="OpenJDK 21;core/openjdk-21"
LABEL_PKI="PKI Private Certificate Authority (CA);infrastructure/easy-rsa-pki"
LABEL_TOMCAT_9="Apache Tomcat 9;infrastructure/tomcat-9"
LABEL_FORGEROCK_DS="ForgeRock Directory Server;infrastructure/forgerock-ds"
LABEL_FORGEROCK_AM="ForgeRock Access Management;infrastructure/forgerock-am"
LABEL_HCP_VAULT="HashiCorp Vault;infrastructure/hcp-vault"
LABEL_HCP_CONSUL="HashiCorp Consul;infrastructure/hcp-consul"
LABEL_PROMETHEUS="Remal Prometheus;monitoring/prometheus"
LABEL_GRAFANA="Remal Grafana;monitoring/grafana"
LABEL_JAVA_21_RUNNER="Remal Java 21 Runner;application/java-21-runner"
LABEL_JAVA_21_POSTGRES_RUNNER="Remal Java 21 with Postgres Runner;application/java-21-postgres-runner"

COLOR_GREEN="\e[38;5;118m"
COLOR_YELLOW="\e[38;5;226m"
STYLE_BOLD="\033[1m"
STYLE_DEFAULT="\033[0m"

# ------------------------------------------------------------------------------
# Copy artifact to a Docker Volume.
#
# Arguments:
#    arg 1: project name
# ------------------------------------------------------------------------------
function copy_to_volume {
  local project source_dir target_dir
  project="$1"
  source_dir="$WORKSPACE/projects/$project/target/"
  target_dir="$WORKSPACE/bin/$project"

  printf "\n%b> coping artifact to a Docker shared volume...%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"
  printf "     source: '%s'\n" "$source_dir$project-*.jar"
  printf "     target: '%s'\n" "$target_dir"

  # to ensure this never expands to /*
  rm -rf "${target_dir:?}/"*
  mkdir -p "$target_dir"
  rsync --archive \
        --include '*.jar' \
        --exclude '**' \
        --verbose \
        "$source_dir" \
        "$target_dir"
}

# ------------------------------------------------------------------------------
# Deploy a docker container and run it in the background.
#
# Arguments:
#    arg 1: relative directory that points to the image source code
# ------------------------------------------------------------------------------
function demo_start {
  local dir environment_file docker_compose_file
  dir="$1"
  environment_file="$WORKSPACE/$dir/$ENVIRONMENT_FILE"
  docker_compose_file="$WORKSPACE/$dir/docker-compose.yml"

  printf "\n%b> starting the '%s' docker stack...%b\n" "$COLOR_YELLOW" "Demo" "$STYLE_DEFAULT"
  printf "       environment-file: '%s'\n" "$environment_file"
  printf "     docker-compose.yml: '%s'\n" "$docker_compose_file"

  copy_to_volume "remal-gombi-user-service"
  copy_to_volume "remal-gombi-welcome-service"
  docker compose --env-file="$environment_file" -f "$docker_compose_file" up
}

# ------------------------------------------------------------------------------
# Show the logs of running Docker containers.
# ------------------------------------------------------------------------------
function docker_container_logs {
  printf "%b> showing the containers' logs...%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"

  local running_containers_number
  running_containers_number="$(docker ps -q --filter "label=com.remal.image.vendor=Remal" | wc -l)"

  if [ "$running_containers_number" -eq 0 ]; then
    printf "no running container\n"
  else
    docker ps -q --filter "label=com.remal.image.vendor=Remal" | xargs -L 1 docker logs --follow
  fi
}

# ------------------------------------------------------------------------------
# Stop and remove of all the running Remal Docker containers.
# ------------------------------------------------------------------------------
function docker_container_remove {
  printf "%b> stopping and removing all the Remal Docker containers...%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"

  local running_containers_number
  running_containers_number="$(docker ps -aq --filter "label=com.remal.image.vendor=Remal" | wc -l)"

  if [ "$running_containers_number" -eq 0 ]; then
    printf "there is no container to remove\n"
  else
    docker rm --force $(docker container ls --filter "label=com.remal.image.vendor=Remal" -a -q)
  fi
}

# ------------------------------------------------------------------------------
# Show the running docker containers' details.
# ------------------------------------------------------------------------------
function docker_container_show {
  printf "%b> running/terminated Remal Docker containers%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"

  local running_containers_number
  running_containers_number="$(docker ps -aq --filter "label=com.remal.image.vendor=Remal" | wc -l)"

  if [ "$running_containers_number" -eq 0 ]; then
    printf "no running container\n"
  else
    docker container ls \
      -a \
      --filter "label=com.remal.image.vendor=Remal" \
      --format "{{.ID}}\t{{.Names}}\t{{.Image}}\t{{.CreatedAt}}\t{{.Status}}" | sort -k 2
  fi
}

# ------------------------------------------------------------------------------
# Calls the external Docker build script for building the Docker image.
#
# Arguments:
#    arg 1: task description string
#    arg 2: relative directory that points to the image source code
# ------------------------------------------------------------------------------
function docker_image_build {
  local title dir
  title="$1"
  dir="$2"

  printf "\n%b> building '%s' docker image...%b\n" "$COLOR_YELLOW" "$title" "$STYLE_DEFAULT"
  docker/build.sh "$dir"
}

# ------------------------------------------------------------------------------
# Remove all the Remal Docker images.
# ------------------------------------------------------------------------------
function docker_image_remove {
  printf "%b> removing all the Remal Docker images...%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"
  docker image rm $(docker image ls --filter "label=com.remal.image.vendor=Remal" -q)
}

# ------------------------------------------------------------------------------
# Show of all Remal Docker images.
# ------------------------------------------------------------------------------
function docker_image_show {
  printf "%b> Remal Docker images%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"
  docker images --filter "label=com.remal.image.vendor=Remal" --format "{{.Size}}\t{{.Repository}}:{{.Tag}}\t\t{{.CreatedSince}}\t{{.ID}}" | sort -k 2
}

# ------------------------------------------------------------------------------
# Split string by delimiter and get N-th element, the name.
#
# Arguments:
#    arg 1: string to split
# ------------------------------------------------------------------------------
function get_name {
  local string
  string="$1"
  cut -d';' -f1 <<<"$string" | echo "$(cat)"
}

# ------------------------------------------------------------------------------
# Split string by delimiter and get N-th element, the path.
#
# Arguments:
#    arg 1: string to split
# ------------------------------------------------------------------------------
function get_path {
  local string
  string="$1"
  cut -d';' -f2 <<<"$string"
}

# ------------------------------------------------------------------------------
# Show the execution time of the script.
#
# Arguments:
#    arg 1: start time
#    arg 2: command line arguments
# ------------------------------------------------------------------------------
function show_execution_time() {
  local start execution_time
  start="$1"
  command="$2"
  execution_time=$(($(date +%s) - start))

  if [ -n "$command" ]; then
    printf "\n"
    printf "execution time: %s day %s\n" "$(($(date -d@$execution_time -u +%d)-1))" "$(date -d@$execution_time -u +%H\ hour\ %M\ min\ %S\ sec)"
  fi
}

# ------------------------------------------------------------------------------
# Show error message and exit from the script.
# ------------------------------------------------------------------------------
function show_invalid_task_error() {
  printf "Invalid task!\n"
  exit 1
}

# ------------------------------------------------------------------------------
# Show the manual.
# ------------------------------------------------------------------------------
function show_help() {
  if [ "$1" -eq 0 ]; then
    local script
    script="${0##*/}"

    printf "%bRemal task runner.%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"
    printf "   %bUsage:%b\n" "$STYLE_BOLD" "$STYLE_DEFAULT"
    printf "       %s <task><task>...\n\n" "$script"
    printf "   %bExamples:%b\n" "$STYLE_BOLD" "$STYLE_DEFAULT"
    printf "      %s ab1i: builds %s and %s images and shows image details\n" "$script" "$LABEL_BASE" "$LABEL_JAVA_11"
    printf "      %s r:    remove all running Remal Docker containers\n" "$script"
    printf "      %s vl:   start the Docker stack and show the containers' log\n\n" "$script"
    printf "   %bEnvironment:%b\n" "$STYLE_BOLD" "$STYLE_DEFAULT"
    printf "      BUILD_TYPE: %s\n" "$BUILD_TYPE"
    printf "      REMAL_HOME: %s\n" ""
    printf "      WORKSPACE : %s\n\n" "$WORKSPACE"
    printf "   %bTasks%b:\n" "$STYLE_BOLD" "$STYLE_DEFAULT"
    printf "      %ba:    build the %bBase%b image%b\n" "$COLOR_YELLOW" "$STYLE_BOLD" "$STYLE_DEFAULT$COLOR_YELLOW" "$STYLE_DEFAULT"
    printf "        %ba1:   build %s image%b\n" "$COLOR_GREEN" "$(get_name "$LABEL_BASE")" "$STYLE_DEFAULT"
    printf "      %bb:    build of all %bCore%b images%b\n" "$COLOR_YELLOW" "$STYLE_BOLD" "$STYLE_DEFAULT$COLOR_YELLOW" "$STYLE_DEFAULT"
    printf "        %bb1:   build %s image%b\n" "$COLOR_GREEN" "$(get_name "$LABEL_JAVA_11")" "$STYLE_DEFAULT"
    printf "        %bb2:   build %s image%b\n" "$COLOR_GREEN" "$(get_name "$LABEL_JAVA_17")" "$STYLE_DEFAULT"
    printf "        %bb3:   build %s image%b\n" "$COLOR_GREEN" "$(get_name "$LABEL_JAVA_21")" "$STYLE_DEFAULT"
    printf "      %bc:    build of all %bInfrastructure%b images%b\n" "$COLOR_YELLOW" "$STYLE_BOLD" "$STYLE_DEFAULT$COLOR_YELLOW" "$STYLE_DEFAULT"
    printf "        %bc1:   build %s image%b\n" "$COLOR_GREEN" "$(get_name "$LABEL_PKI")" "$STYLE_DEFAULT"
    printf "        %bc2:   build %s image%b\n" "$COLOR_GREEN" "$(get_name "$LABEL_TOMCAT_9")" "$STYLE_DEFAULT"
    printf "        %bc3:   build %s image%b\n" "$COLOR_GREEN" "$(get_name "$LABEL_FORGEROCK_DS")" "$STYLE_DEFAULT"
    printf "        %bc4:   build %s image%b\n" "$COLOR_GREEN" "$(get_name "$LABEL_FORGEROCK_AM")" "$STYLE_DEFAULT"
    printf "        %bc5:   build %s image%b\n" "$COLOR_GREEN" "$(get_name "$LABEL_HCP_VAULT")" "$STYLE_DEFAULT"
    printf "        %bc6:   build %s image%b\n" "$COLOR_GREEN" "$(get_name "$LABEL_HCP_CONSUL")" "$STYLE_DEFAULT"
    printf "      %bd:    build of all %bMonitoring%b images%b\n" "$COLOR_YELLOW" "$STYLE_BOLD" "$STYLE_DEFAULT$COLOR_YELLOW" "$STYLE_DEFAULT"
    printf "        %bd1:   build %s image%b\n" "$COLOR_GREEN" "$(get_name "$LABEL_PROMETHEUS")" "$STYLE_DEFAULT"
    printf "        %bd2:   build %s image%b\n" "$COLOR_GREEN" "$(get_name "$LABEL_GRAFANA")" "$STYLE_DEFAULT"
    printf "      %be:    build of all %bApplication%b images%b\n" "$COLOR_YELLOW" "$STYLE_BOLD" "$STYLE_DEFAULT$COLOR_YELLOW" "$STYLE_DEFAULT"
    printf "        %be1:   build %s image%b\n" "$COLOR_GREEN" "$(get_name "$LABEL_JAVA_21_RUNNER")" "$STYLE_DEFAULT"
    printf "        %be2:   build %s image%b\n" "$COLOR_GREEN" "$(get_name "$LABEL_JAVA_21_POSTGRES_RUNNER")" "$STYLE_DEFAULT"
    printf "      ------------------------------------------------------------\n"
    printf "      %bstart a Docker environment%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"
    printf "        %bi1:   start the 'Demo' Docker stack%b\n" "$COLOR_GREEN" "$STYLE_DEFAULT"
    printf "      ------------------------------------------------------------\n"
    printf "      %bu:    list Remal Docker images%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"
    printf "      %bv:    list Remal Docker containers%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"
    printf "      %bw:    show Remal Docker containers' log%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"
    printf "      %bx:    remove of all Remal Docker containers%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"
    printf "      %by:    remove of all Remal Docker images%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"
    printf "\n"
    printf "Contact: arnold.somogyi@gmail.com\n"
    printf "Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved\n"
  fi
}

# ------------------------------------------------------------------------------
# Check whether the given task can be executed or not.
#
# Arguments:
#    arg 1: task list from the command line
#    arg 2: id of the task to be validated
# ------------------------------------------------------------------------------
function match {
  local args id group regexp
  args=$(printf "%sz" "$1")
  id="$2";
  group=${id:0:1}
  regexp=$(printf "(%s|%s[a-z])" "$id" "$group")

  if [[ "$args" =~ $regexp ]]; then
    true
  else
    false
  fi
}

# ------------------------------------------------------------------------------
# Check whether the given task list contains an invalid task or not.
# Rules:
#    * A task is invalid if it contains only letter, e.g "a".
#    * A task is valid if it contains letter and a belonging number, e.g "a1".
#
# Arguments:
#    arg 1: task list from the command line
#    arg 2: id of the task to be validated
# ------------------------------------------------------------------------------
function is_task_invalid {
  local args id regexp
  args=$(printf "%sz" "$1")
  id="$2";
  regexp=$(printf ".*%s[0-9].*" "$id")

  if [[ "$args" != *"$id"* ]]; then
    # ignore because args and id are different
    false
  else
    if [[ "$args" =~ $regexp ]]; then
      false
    else
      true
    fi
  fi
}

# ------------------------------------------------------------------------------
# Main program starts here.
# ------------------------------------------------------------------------------
show_help "$#"
START=$(date +%s)

# command executors
if match "$COMMAND" "x";  then docker_container_remove; fi
if match "$COMMAND" "y";  then docker_image_remove; fi

# builder tasks
# if is_task_invalid "$COMMAND" "a"; then show_invalid_task_error; fi
if match "$COMMAND" "a1"; then docker_image_build "$(get_name "$LABEL_BASE")" "$(get_path "$LABEL_BASE")"; fi
if match "$COMMAND" "b1"; then docker_image_build "$(get_name "$LABEL_JAVA_11")" "$(get_path "$LABEL_JAVA_11")"; fi
if match "$COMMAND" "b2"; then docker_image_build "$(get_name "$LABEL_JAVA_17")" "$(get_path "$LABEL_JAVA_17")"; fi
if match "$COMMAND" "b3"; then docker_image_build "$(get_name "$LABEL_JAVA_21")" "$(get_path "$LABEL_JAVA_21")"; fi
if match "$COMMAND" "c1"; then docker_image_build "$(get_name "$LABEL_PKI")" "$(get_path "$LABEL_PKI")"; fi
if match "$COMMAND" "c2"; then docker_image_build "$(get_name "$LABEL_TOMCAT_9")" "$(get_path "$LABEL_TOMCAT_9")"; fi
if match "$COMMAND" "c3"; then docker_image_build "$(get_name "$LABEL_FORGEROCK_DS")" "$(get_path "$LABEL_FORGEROCK_DS")"; fi
if match "$COMMAND" "c4"; then docker_image_build "$(get_name "$LABEL_FORGEROCK_AM")" "$(get_path "$LABEL_FORGEROCK_AM")"; fi
if match "$COMMAND" "c5"; then docker_image_build "$(get_name "$LABEL_HCP_VAULT")" "$(get_path "$LABEL_HCP_VAULT")"; fi
if match "$COMMAND" "c6"; then docker_image_build "$(get_name "$LABEL_HCP_CONSUL")" "$(get_path "$LABEL_HCP_CONSUL")"; fi
if match "$COMMAND" "d1"; then docker_image_build "$(get_name "$LABEL_PROMETHEUS")" "$(get_path "$LABEL_PROMETHEUS")"; fi
if match "$COMMAND" "d2"; then docker_image_build "$(get_name "$LABEL_GRAFANA")" "$(get_path "$LABEL_GRAFANA")"; fi
if match "$COMMAND" "e1"; then docker_image_build "$(get_name "$LABEL_JAVA_21_RUNNER")" "$(get_path "$LABEL_JAVA_21_RUNNER")"; fi
if match "$COMMAND" "e2"; then docker_image_build "$(get_name "$LABEL_JAVA_21_POSTGRES_RUNNER")" "$(get_path "$LABEL_JAVA_21_POSTGRES_RUNNER")"; fi

# command executors
if match "$COMMAND" "u";  then docker_image_show; fi
if match "$COMMAND" "v";  then docker_container_show; fi

# docker runners
if match "$COMMAND" "i1"; then demo_start "projects"; fi

if match "$COMMAND" "w";  then docker_container_logs; fi

show_execution_time "$START" "$#"
printf "Bye!\n"
