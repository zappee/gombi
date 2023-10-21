#!/bin/bash -ue
# ******************************************************************************
# Remal Docker image builder.
#
# Since : January, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
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
SCRIPT_PATH=$(dirname "$SCRIPT")
IMAGE_SRC=$SCRIPT_PATH/${1##*docker/}
printf "Script home: %s\n" "$SCRIPT_PATH"
printf "Source code: %s\n" "$IMAGE_SRC"

source "$IMAGE_SRC/setenv.sh" "slim" "false"
printf "Build type:  %s\n" "$BUILD_TYPE"
printf "Base image:  %s\n" "$IMAGE_FROM"
printf "Image image:  %s\n\n" "$IMAGE_NAME:$IMAGE_TAG"

docker build \
  --no-cache \
  --build-arg BUILD_TYPE="$BUILD_TYPE" \
  --build-arg IMAGE_NAME="$IMAGE_NAME" \
  --build-arg IMAGE_TAG="$IMAGE_TAG" \
  --build-arg IMAGE_DESCRIPTION="$IMAGE_DESCRIPTION" \
  --build-arg IMAGE_AUTHOR="$IMAGE_AUTHOR" \
  --build-arg IMAGE_FROM="$IMAGE_FROM" \
  --tag "$IMAGE_NAME":"$IMAGE_TAG" \
  "$IMAGE_SRC"

printf "cleaning up unused Docker images and containers...\n"
docker ps --filter status=exited --filter status=created --quiet | xargs -r docker rm --volumes
docker image prune --force

if [ "$PUSH_IMAGE" = true ] ; then
  printf "pushing the image to the registry...\n"
  docker push "$IMAGE_NAME":"$IMAGE_TAG"
fi
