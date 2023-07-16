# Release info

All notable changes to this project will be documented in this file.

## [0.0.1] - 13/Mar/2023
#### Added
* `bash` and `sh` Unix shells
* ssh server
* `root` user password set to `password`
* configure the bash console for ssh login
* customized bash prompt that shows the container name and version
* `ll` and `ls` bash aliases
* execution of scripts files from `/docker.first-boot` directory during the very first star of the container
* execution of script files from `/docker.startup` directory when the container starts
* `shutdown-actions.sh` script, called before container stops completely
