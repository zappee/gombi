# Remal Gombi

## 1) Overview
This is an integrated development framework running in Docker containers. The containers can be used in `production` environments as well.

Gombi provides the following services:
- _Private Certificate Authority infrastructure (PKI)_
- _LDAP Directory Service_
- _Access Management infrastructure_: authentication, authorization, OAUTH2, etc.
- _Distributed key/value store_: identity-based secret and encryption management system to store key/values with Hashicorp Vault
- _Distributed event streaming platform_: high-performance data pipelines, streaming analytics and data integration with Kafka
- _A powerful open-source distributed and scalable in-memory data cache_
- _Data Analytics & Visualization platforms_: to search, analyze and visualize the machine-generated data and events gathered from the applications, sensors, devices etc.
- _Java 11, 17 and 21 containers as a service (CaaS)_: run Spring Boot applications/microservices

![docker image hierarchy](docs/diagrams/images/docker-image-hierarchy.png)

## 2) Docker Images provided
* Base Image:
  * [Remal Base](docker/base/base): based on Alpine


* Java JDK Images:
  * [OpenJDK-11](docker/core/openjdk-11)
  * [OpenJDK-17](docker/core/openjdk-17)
  * [OpenJDK-21](docker/core/openjdk-21)


* Private Certificate Authority Server (PKI):
  * [OpenVPN/Easy-RSA](docker/infrastructure/easy-rsa-pki): complete Private Certificate Authority Server to manage the server certificates


* Access Management platform: 
  * [ForgeRock Access Management platform](docker/infrastructure/forgerock-am): Authentication, Authorization, OAUTH, SSO, Federation, etc.
  * [ForgeRock Directory Service](docker/infrastructure/forgerock-ds): LDAP server


* Distributed Service Registry and key/value store:
  * [Hashicorp Consul](docker/infrastructure/hcp-consul): Service Registry and Discovery + distributed key/value store
  * [Hashicorp Vault](docker/infrastructure/hcp-vault): key/value store


* Jave Web Container Images
  * [Apache Tomcat 9](docker/infrastructure/tomcat-9)


* Monitoring, analytics and interactive visualization:
  * [Prometheus](docker/monitoring/prometheus): event monitoring, collecting and alerting, it records metrics in a time series database
  * [Grafana](docker/monitoring/grafana): analytics and interactive visualization web application with charts, graphs, and alerts


* Java runners
  * [OpenJDK-21 Runner](docker/application/java-21-runner)
  * [OpenJDK-21 Runner with Postgres Database Server](docker/application/java-21-postgres-runner)


## 3) Build the images

## 4) How to start
1. Build the sample projects
    ~~~
    $ cd gombi/projects
    $ mvn clean package 
    ~~~

2. Copy the artifacts (*.war) into the directory that will be mapped into the `Java Runners` container.

   The default directories:
   * `$HOME/Java/gombi/bin/echo-service`
   * `$HOME/Java/gombi/bin/user-service`

   The path cen be changed in the compose file: `projects/docker-compose.yml`

3. Start the Remal-Gombi Docker stack
    ~~~
    $ cd gombi/projects
    $ mvn clean package 
    ~~~


## 5) License and Copyright
Copyright (c) 2020-2025 Remal Software, Arnold Somogyi. All rights reserved.

## Appendix 1) Reference Dockerfile
* Reference Dockerfile: [docker/docker-compose-reference.yml](docker/docker-compose-reference.yml) file.
* For more details, check [this](docker/README.md).

<a href="https://trackgit.com">
  <img src="https://us-central1-trackgit-analytics.cloudfunctions.net/token/ping/lcfhkdub7k2lpj33n2cl" alt="trackgit-views" />
</a>
