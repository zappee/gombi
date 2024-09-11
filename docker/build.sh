#!/bin/bash -ue
# ******************************************************************************
# Remal Docker image builder.
#
# Since:  January 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
#
# Usage:
#    $ ./build.sh <image-source-dir>
#
#    where the source-dir must point to the directory that holds the image
#    source code
# ******************************************************************************
if [ "$#" -ne 1 ]; then
  printf "[ERROR] Illegal number of parameters.\n"
  printf "Usage: %s <image-source-relative-path>\n\n" "${0##*/}"
  exit 1
fi

SCRIPT=$(realpath "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")
IMAGE_SRC=$SCRIPT_PATH/${1##*docker/}
. "$IMAGE_SRC/setenv.sh" "slim" "false" "hello.com"

printf "script home:  %s\n" "$SCRIPT_PATH"
printf "source code:  %s\n" "$IMAGE_SRC"
printf "build type:   %s\n" "$BUILD_TYPE"
printf "image name:   %s\n" "$IMAGE_NAME"
printf "image vendor: %s\n" "$IMAGE_VENDOR"
printf "image author: %s\n" "$IMAGE_AUTHOR"
printf "image from:   %s\n" "$IMAGE_FROM"
printf "image tag:    %s\n\n" "$IMAGE_TAG"

docker build \
  --no-cache \
  --build-arg BUILD_TYPE="$BUILD_TYPE" \
  --build-arg IMAGE_NAME="$IMAGE_NAME" \
  --build-arg IMAGE_TAG="$IMAGE_TAG" \
  --build-arg IMAGE_DESCRIPTION="$IMAGE_DESCRIPTION" \
  --build-arg IMAGE_VENDOR="$IMAGE_VENDOR" \
  --build-arg IMAGE_AUTHOR="$IMAGE_AUTHOR" \
  --build-arg IMAGE_FROM="$IMAGE_FROM" \
  --tag "$IMAGE_NAME":"$IMAGE_TAG" \
  --progress plain \
  "$IMAGE_SRC"

EXIT_CODE=$?
if [ "$EXIT_CODE" -ne 0 ]; then
  printf "An unexpected error has appeared during the \"%s\" image build.\n" "$IMAGE_TAG"
  exit 110
fi

printf "cleaning up unused Docker images and containers...\n"
docker ps --filter status=exited --filter status=created --quiet | xargs -r docker rm --volumes
docker image prune --force

if [ "$PUSH_IMAGE" = true ]; then
  printf "pushing the image to the registry...\n"
  docker push "$IMAGE_NAME":"$IMAGE_TAG"
fi

printf "Image has been built successfully. Details:\n"
printf "   - script home: %s\n" "$SCRIPT_PATH"
printf "   - source code: %s\n" "$IMAGE_SRC"
printf "   - build type:  %s\n" "$BUILD_TYPE"
printf "   - base image:  %s\n" "$IMAGE_FROM"
printf "   - image image: %s\n\n" "$IMAGE_NAME:$IMAGE_TAG"
