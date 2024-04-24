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

## [0.0.2] - 24/Apr/2024
#### Modified
* Improvement in the `wait_until_text_found` method of the `shared.sh` script.
* Improvement in log.

<a href="https://trackgit.com">
  <img src="https://us-central1-trackgit-analytics.cloudfunctions.net/token/ping/lcfhkdub7k2lpj33n2cl" alt="trackgit-views" />
</a>
