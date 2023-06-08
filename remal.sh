#!/bin/bash -ue
# ******************************************************************************
#  Remal Docker Image build file.
#
#  Since : January, 2023
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
#
#  Usage:
#     1) Set the REMAL_HOME environment variable.
#        It must point to the project directory. If the variable is not set then
#        the current directory is used as a home directory.
#        Example: export REMAL_HOME="$HOME/Java/gombi"
#
#    2) Run the script using ./remal.sh
# ******************************************************************************
WORKSPACE="${REMAL_HOME:-$(pwd)}"
BUILD_TYPE="slim"
COMMAND="${1:-}"

LABEL_AM="Access Management (AM)"
LABEL_BASE="Base"
LABEL_DS="Directory Server (DS)"
LABEL_JAVA_11="OpenJDK 11 (Java)"
LABEL_JAVA_17="OpenJDK 17 (Java)"
LABEL_PKI="PKI Private Certificate Authority (CA)"
LABEL_TOMCAT_9="Apache Tomcat 9 (Tomcat)"

COLOR_GREEN="\e[38;5;118m"
COLOR_YELLOW="\e[38;5;226m"
STYLE_BOLD="\033[1m"
STYLE_DEFAULT="\033[0m"

# ------------------------------------------------------------------------------
#  Show the logs of running Docker containers.
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
#  Stop and remove of all running Remal Docker containers.
# ------------------------------------------------------------------------------
function docker_container_remove {
  printf "%b> stopping and removing the Remal Docker containers...%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"

  local running_containers_number
  running_containers_number="$(docker ps -aq --filter "label=com.remal.image.vendor=Remal" | wc -l)"

  if [ "$running_containers_number" -eq 0 ]; then
    printf "there is no container to remove\n"
  else
    docker rm --force $(docker container ls --filter "label=com.remal.image.vendor=Remal" -a -q)
  fi
}

# ------------------------------------------------------------------------------
#  Deploy a docker container and run it in the background.
# ------------------------------------------------------------------------------
function docker_container_run {
  local title dir
  title="$1"
  dir="$2"

  printf "\n%b> starting the '%s' docker container...%b\n" "$COLOR_YELLOW" "$title" "$STYLE_DEFAULT"
  cd "$WORKSPACE/docker/$dir"
  ./start.sh
  cd "$WORKSPACE"
}

# ------------------------------------------------------------------------------
#  Show the running docker containers' details.
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
#  Starting the full Remal Docker stack.
# ------------------------------------------------------------------------------
function docker_containers_run {
  printf "%b> starting the Remal Docker stack...%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"
  cd "$WORKSPACE/docker"
  docker-compose up
  cd "$WORKSPACE"
}

# ------------------------------------------------------------------------------
#  Calls the external Docker build script for building the Docker image.
#
#  Arguments:
#     arg 1: task description string
#     arg 2: relative directory that points to the image source code
# ------------------------------------------------------------------------------
function docker_image_build {
  local title dir
  title="$1"
  dir="$2"

  printf "\n%b> building '%s' docker image...%b\n" "$COLOR_YELLOW" "$title" "$STYLE_DEFAULT"
  docker/build.sh "$dir"
}

# ------------------------------------------------------------------------------
#  Show of all Remal Docker images.
# ------------------------------------------------------------------------------
function docker_image_show {
  printf "%b> Remal Docker images%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"
  docker images --filter "label=com.remal.image.vendor=Remal" --format "{{.Size}}\t{{.Repository}}:{{.Tag}}\t\t{{.CreatedSince}}\t{{.ID}}" | sort -k 2
}

# ------------------------------------------------------------------------------
#  Show the execution time of the script.
#
#  Arguments:
#     arg 1: start time
#     arg 2: command line arguments
# ------------------------------------------------------------------------------
function show_execution_time() {
  local start execution_time
  start="$1"
  command="$2"
  execution_time=$(($(date +%s) - start))

  if [ -n "$command" ]; then
    printf "execution time: %s day %s\n" "$(($(date -d@$execution_time -u +%d)-1))" "$(date -d@$execution_time -u +%H\ hour\ %M\ min\ %S\ sec)"
  fi
}

# ------------------------------------------------------------------------------
#  Show error message and exit from the script.
# ------------------------------------------------------------------------------
function show_invalid_task_error() {
  printf "Invalid task!\n"
  exit 1
}

# ------------------------------------------------------------------------------
#  Show the manual.
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
    printf "      %ba:    build the Master image%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"
    printf "      %bb:    build of all Base images%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"
    printf "        %bb1:   build %s image%b\n" "$COLOR_GREEN" "$LABEL_JAVA_11" "$STYLE_DEFAULT"
    printf "        %bb2:   build %s image%b\n" "$COLOR_GREEN" "$LABEL_JAVA_17" "$STYLE_DEFAULT"
    printf "        %bb3:   build %s image%b\n" "$COLOR_GREEN" "$LABEL_TOMCAT_9" "$STYLE_DEFAULT"
    printf "      %bc:    build %s image%b\n" "$COLOR_YELLOW" "$LABEL_PKI" "$STYLE_DEFAULT"
    printf "      %bd:    build forgerock images%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"
    printf "        %bd1:   build %s image%b\n" "$COLOR_GREEN" "$LABEL_DS" "$STYLE_DEFAULT"
    printf "        %bd2:   build %s image%b\n" "$COLOR_GREEN" "$LABEL_AM" "$STYLE_DEFAULT"
    printf "      ------------------------------------------------------------\n"
    printf "      %bs:    start the complete Docker stack%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"
    printf "        %bt1:   start %s container%b\n" "$COLOR_GREEN" "$LABEL_BASE" "$STYLE_DEFAULT"
    printf "        %bt2:   start %s container%b\n" "$COLOR_GREEN" "$LABEL_JAVA_11" "$STYLE_DEFAULT"
    printf "        %bt3:   start %s container%b\n" "$COLOR_GREEN" "$LABEL_JAVA_17" "$STYLE_DEFAULT"
    printf "        %bt4:   start %s container%b\n" "$COLOR_GREEN" "$LABEL_TOMCAT_9" "$STYLE_DEFAULT"
    printf "        %bt5:   start %s container%b\n" "$COLOR_GREEN" "$LABEL_PKI" "$STYLE_DEFAULT"
    printf "        %bt6:   start %s container%b\n" "$COLOR_GREEN" "$LABEL_DS" "$STYLE_DEFAULT"
    printf "        %bt7:   start %s container%b\n" "$COLOR_GREEN" "$LABEL_AM" "$STYLE_DEFAULT"
    printf "      ------------------------------------------------------------\n"
    printf "      %bu:    show images%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"
    printf "      %bv:    show containers%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"
    printf "      %bw:    show Docker containers' log%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"
    printf "      %bx:    remove of all running Remal Docker containers%b\n" "$COLOR_YELLOW" "$STYLE_DEFAULT"
    printf "\n"
    printf "Contact: arnold.somogyi@gmail.com\n"
    printf "Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved\n"
  fi
}

# ------------------------------------------------------------------------------
#  Check whether the given task can be executed or not.
#
#  Arguments:
#     arg 1: task list from the command line
#     arg 2: id of the task to be validated
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
#  Check whether the given task list contains an invalid task or not.
#  A task is invalid if it contains only letter, e.g "a".
#  A task is valid if it contains letter and a belonging number , e.g "a1".
#
#  Arguments:
#     arg 1: task list from the command line
#     arg 2: id of the task to be validated
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
#  Main program starts here.
# ------------------------------------------------------------------------------
show_help "$#"
START=$(date +%s)

# builder tasks
# if is_task_invalid "$COMMAND" "a"; then show_invalid_task_error; fi
if match "$COMMAND" "a1"; then docker_image_build   "$LABEL_BASE"     "base"; fi
if match "$COMMAND" "b1"; then docker_image_build   "$LABEL_JAVA_11"  "java/openjdk-11"; fi
if match "$COMMAND" "b2"; then docker_image_build   "$LABEL_JAVA_17"  "java/openjdk-17"; fi
if match "$COMMAND" "b3"; then docker_image_build   "$LABEL_TOMCAT_9" "tomcat/tomcat-9"; fi
if match "$COMMAND" "c";  then docker_image_build   "$LABEL_PKI"      "pki/private-ca"; fi
if match "$COMMAND" "d1"; then docker_image_build   "$LABEL_DS"       "forgerock/forgerock-ds"; fi
if match "$COMMAND" "d2"; then docker_image_build   "$LABEL_AM"       "forgerock/forgerock-am"; fi

# docker runners
if match "$COMMAND" "t1"; then docker_container_run "$LABEL_BASE"     "base"; fi
if match "$COMMAND" "t2"; then docker_container_run "$LABEL_JAVA_11"  "java/openjdk-11"; fi
if match "$COMMAND" "t3"; then docker_container_run "$LABEL_JAVA_17"  "java/openjdk-17"; fi
if match "$COMMAND" "t4"; then docker_container_run "$LABEL_TOMCAT_9" "tomcat/tomcat-9"; fi
if match "$COMMAND" "t5"; then docker_container_run "$LABEL_PKI"      "pki/private-ca"; fi
if match "$COMMAND" "t6"; then docker_container_run "$LABEL_DS"       "forgerock/forgerock-ds"; fi
if match "$COMMAND" "t7"; then docker_container_run "$LABEL_AM"       "forgerock/forgerock-am"; fi

# command executors
if match "$COMMAND" "x";  then docker_container_remove; fi
if match "$COMMAND" "u";  then docker_image_show; fi
if match "$COMMAND" "v";  then docker_container_show; fi
if match "$COMMAND" "s";  then docker_containers_run; fi
if match "$COMMAND" "w";  then docker_container_logs; fi

show_execution_time "$START" "$#"
printf "Bye!\n"