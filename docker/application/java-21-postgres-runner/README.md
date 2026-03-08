# Remal Image: Java 21 Runner with Postgres

## Postgres

### Persist data in a dockerized postgres database using volumes
* docker-compose.yml
    ```
    services:
        user-service:
            image: remal-java-21-postgres-runner:0.6.2
            ...
            volumes:
                - user-service-data:/var/lib/postgresql/data
    
    volumes:
        user-service-data:
            driver: local
    ```
* list volumes
    ```
  $ docker volume ls
  ...
  local     projects_user-service-data
    ```
* delete unused volumes
    ```
  $ docker volume prune --all
    ```
* backup volume

  Normally, if you want to back up a data volume, you start a new container using the volume you want to back up, then execute the tar command to produce an archive of the volume content:
    ```
    $ VOLUME_NAME=projects_user-service-data
  
    $ docker run --rm \
       --volume "$VOLUME_NAME":/volume \
       --volume "$(pwd)":/backup \
       busybox \
       tar -zcvf /backup/"$VOLUME_NAME".tar.gz -C /volume .
    ```
* restore volume
    ```
    $ docker run --rm \
         --volume "$VOLUME_NAME":/volume \
         --volume $(pwd):/backup \
         busybox sh -c "cd /volume && tar xzf /backup/"$VOLUME_NAME".tar.gz"
    ```


### Useful SQL commands
| Function                            | SQL                                |
|-------------------------------------|------------------------------------|
| Determine the version of the server | `SELECT version()`                 |
| List databases                      | `SELECT datname FROM pg_database`  |
| List Users                          | `SELECT * FROM pg_catalog.pg_user` |

<a href="https://trackgit.com">
  <img src="https://us-central1-trackgit-analytics.cloudfunctions.net/token/ping/lcfhkdub7k2lpj33n2cl" alt="trackgit-views" />
</a>
