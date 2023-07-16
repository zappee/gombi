# Remal Gombi

## 1) Overview
This is an integrated development framework running in Docker containers.
The environment provides the following services:
- Private Certificate Authority infrastructure: issue server certificates (PKI)
- Directory Service: store user data (LDAP)
- Access Management infrastructure: OAUTH2, etc.
- Secured Vault: Service Self Registration, Application Configurations, etc.

The framework provides the following base Docker images:
- OpenJDK 11 and 17 base Docker images
- Apache Tomcat 9 base image

![docker image hierarchy](docs/uml/docker/docker-image-hierarchy.png)

## 2) Components of the environment
* Base Docker Images:
  * [Remal Base](docker/base)
  * [OpenJDK-11](docker/java/openjdk-11)
  * [OpenJDK-17](docker/java/openjdk-17)
  * [Apache Tomcat 9](docker/tomcat/tomcat-9)
* Service Docker Images:
  * Private Certificate Authority (CA) Infrastructure: [OpenVPN easy-rsa (simple shell based CA utility)]()
  * Vault Service: [HashiCorp Vault](docker/vault/hcp-vault)
  * Directory Service (LDAP): [ForgeRock Directory Server](docker/forgerock/forgerock-ds)
  * Access Management (LDAP): [ForgeRock Access Management](docker/forgerock/forgerock-am)

## 3) Deployment 
For more details, check [this](docker/README.md).

## 4) Demo application

## 5) License and Copyright
Copyright (c) 2020-2023 Remal Software, Arnold Somogyi. All rights reserved.
