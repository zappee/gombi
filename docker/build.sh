#!/bin/bash -ue
# ******************************************************************************
# Remal Docker image builder.
#
# Since:  January 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
#
# Usage:
#    $ ./build.sh <image-source-dir>
#
#    where the source-dir must point to the directory that holds the image
#    source code
# ******************************************************************************

# ------------------------------------------------------------------------------
# Build the Docker image.
# ------------------------------------------------------------------------------
function docker_build() {
  show_build_info "The following build arguments will be used"

  docker build \
    --build-arg "BUILDKIT_DOCKERFILE_CHECK=skip=SecretsUsedInArgOrEnv" \
    --no-cache \
    --build-arg BUILD_TYPE="$BUILD_TYPE" \
    --build-arg IMAGE_FROM="$IMAGE_FROM" \
    --build-arg IMAGE_NAME="$IMAGE_NAME" \
    --build-arg IMAGE_TAG="$IMAGE_TAG" \
    --build-arg IMAGE_AUTHOR="$IMAGE_AUTHOR" \
    --build-arg IMAGE_DESCRIPTION="$IMAGE_DESCRIPTION" \
    --tag "$IMAGE_NAME":"$IMAGE_TAG" \
    --progress plain \
    "$IMAGE_SRC"
}

# ------------------------------------------------------------------------------
# Remove all unused docker containers and images.
# ------------------------------------------------------------------------------
function docker_prune() {
  printf -- "------------------------------------------------------------------------\n"
  printf "cleaning up unused Docker images and containers...\n"
  printf -- "------------------------------------------------------------------------\n"
  docker ps --filter status=exited --filter status=created --quiet | xargs -r docker rm --volumes
  docker image prune --force
}

# ------------------------------------------------------------------------------
# Push image to Docker-Registry to share it.
# ------------------------------------------------------------------------------
function docker_push() {
  if [ "$PUSH_IMAGE" = true ] ; then
    printf -- "------------------------------------------------------------------------\n"
    printf "pushing the image to the registry...\n"
    printf -- "------------------------------------------------------------------------\n"
    docker push "$IMAGE_NAME":"$IMAGE_TAG"
  fi
}

# ------------------------------------------------------------------------------
# Set the environment variables.
# ------------------------------------------------------------------------------
function set_context() {
  local script_to_run="$IMAGE_SRC/setenv.sh"
  printf "Sourcing \"%s\" script...\n" "$script_to_run"
  source "$script_to_run" "$IMAGE_TAG"
}

# ------------------------------------------------------------------------------
# Shows the arguments that are used during the image build.
#
# Parameters:
#    param 1: label to show
# ------------------------------------------------------------------------------
function show_build_info() {
  printf "%s:\n" "$1"
  printf "   - image source home: \"%s\"\n" "$IMAGE_SRC"
  printf "   - build type:        \"%s\"\n" "$BUILD_TYPE"
  printf "   - image from:        \"%s\"\n" "$IMAGE_FROM"
  printf "   - image name:        \"%s\"\n" "$IMAGE_NAME"
  printf "   - image tag:         \"%s\"\n" "$IMAGE_TAG"
  printf "   - image author:      \"%s\"\n" "$IMAGE_AUTHOR"
  printf "   - image description: \"%s\"\n" "$IMAGE_DESCRIPTION"
  printf "   - push image:        \"%s\"\n" "$PUSH_IMAGE"
}

# ------------------------------------------------------------------------------
# Validates the script startup arguments.
#
# Parameters:
#    param 1: startup arguments of the script
# ------------------------------------------------------------------------------
function validate_arguments() {
  if [ "$#" -ne 4 ]; then
    printf "[ERROR] Illegal number of parameters.\n"
    printf "Usage: %s <src-home> <build-type> <image-tag> <push-image>\n\n" "${0##*/}"
    exit 1
  fi
}

# ------------------------------------------------------------------------------
# Main program starts here.
# ------------------------------------------------------------------------------
CURRENT_SCRIPT=$(realpath "$0")
PATH_OF_CURRENT_SCRIPT=$(dirname "$CURRENT_SCRIPT")

IMAGE_SRC="$PATH_OF_CURRENT_SCRIPT/$1"
BUILD_TYPE="$2"
IMAGE_TAG="$3"
PUSH_IMAGE="$4"

validate_arguments "$@"
set_context
docker_build
docker_prune
docker_push
show_build_info "Image has been built successfully with"
