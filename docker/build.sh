#!/bin/bash -ue
# ******************************************************************************
# Remal Docker image builder.
#
# Since : January, 2023
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
if [ "$#" -ne 1 ]; then
  printf "[ERROR] Illegal number of parameters.\n"
  printf "Usage: %s <image-source-dir>\n\n" "${0##*/}"
  exit 1
fi

SCRIPT=$(realpath "$0")
SCRIPT_HOME=$(dirname "$SCRIPT")
IMAGE_SRC="$SCRIPT_HOME/$1"
IMAGE_TAG="0.2.0"

# set environment
. "$IMAGE_SRC/setenv.sh" "slim" "false" "remal.com" "$IMAGE_TAG"

printf "SCRIPT_HOME: %s\n" "$SCRIPT_HOME"
printf "IMAGE_SRC:   %s\n" "$IMAGE_SRC"
printf "BUILD_TYPE:  %s\n" "$BUILD_TYPE"
printf "IMAGE_FROM:  %s\n" "$IMAGE_FROM"
printf "image name:  %s\n\n" "$IMAGE_NAME:$IMAGE_TAG"

docker build \
  --build-arg "BUILDKIT_DOCKERFILE_CHECK=skip=SecretsUsedInArgOrEnv" \
  --no-cache \
  --build-arg BUILD_TYPE="$BUILD_TYPE" \
  --build-arg IMAGE_NAME="$IMAGE_NAME" \
  --build-arg IMAGE_TAG="$IMAGE_TAG" \
  --build-arg IMAGE_DESCRIPTION="$IMAGE_DESCRIPTION" \
  --build-arg IMAGE_AUTHOR="$IMAGE_AUTHOR" \
  --build-arg IMAGE_FROM="$IMAGE_FROM" \
  --tag "$IMAGE_NAME":"$IMAGE_TAG" \
  --progress plain \
  "$IMAGE_SRC"

printf "cleaning up unused Docker images and containers...\n"
docker ps --filter status=exited --filter status=created --quiet | xargs -r docker rm --volumes
docker image prune --force

if [ "$PUSH_IMAGE" = true ] ; then
  printf "pushing the image to the registry...\n"
  docker push "$IMAGE_NAME":"$IMAGE_TAG"
fi

printf "Image has been built successfully. Details:\n"
printf "   - SCRIPT_HOME: %s\n" "$SCRIPT_HOME"
printf "   - IMAGE_SRC:   %s\n" "$IMAGE_SRC"
printf "   - BUILD_TYPE:  %s\n" "$BUILD_TYPE"
printf "   - IMAGE_FROM:  %s\n" "$IMAGE_FROM"
printf "   - image image: %s\n\n" "$IMAGE_NAME:$IMAGE_TAG"
