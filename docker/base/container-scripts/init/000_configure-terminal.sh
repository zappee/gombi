#!/bin/bash -ue
# ******************************************************************************
# Bash environment configuration in Docker environment.
#
# Since : May, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
printf "%s | [DEBUG] -----------------------------------------------------------\n" "$(date +"%Y-%b-%d %H:%M:%S")"
printf "%s | [DEBUG] executing the \"%s\" script...\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$0"
printf "%s | [DEBUG] ===========================================================\n" "$(date +"%Y-%b-%d %H:%M:%S")"

{
  printf "%s\n" "alias ll='ls -alF'"
  printf "%s\n" "alias ls='ls --color=auto'"
  printf "%s\n" "PS1='${IMAGE_NAME}:${IMAGE_TAG}:[\u@\H]\\$ '"
} >> ~/.bashrc

{
  printf "export %s=\"%s\"\n" "IMAGE_NAME" "$IMAGE_NAME"
  printf "export %s=\"%s\"\n" "IMAGE_TAG" "$IMAGE_TAG"
  printf "export %s=\"%s\"\n" "IMAGE_DESCRIPTION" "$IMAGE_DESCRIPTION"
  printf "export %s=\"%s\"\n" "IMAGE_AUTHOR" "$IMAGE_AUTHOR"
  printf "export %s=\"%s\"\n" "SSH_USER" "$SSH_USER"
  printf "export %s=\"%s\"\n" "SSH_PASSWORD" "$SSH_PASSWORD"
  printf "export %s=\"%s\"\n" "UP_SIGNAL_PORT" "$UP_SIGNAL_PORT"
} >> /etc/profile
