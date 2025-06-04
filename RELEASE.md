# Release info

All notable changes to this project will be documented in this file.

## [0.6.0] - 13/Jun/2025
#### Docker Images
* Update `alpine` version from `3.21.2` to `3.22.0` in the `base` image
* Update `Hashicorp Consul` version from `1.20.2` to `1.21.1` in the `hcp-consul` image
* Update `Hashicorp Vault` version from `1.18.4` to `1.19.5` in the `hcp-vault` image
* Update `Grafana Enterprise` version from `11.5.1` to `12.0.1` in the `grafana` image
* Update `Prometheus` version from `3.1.0` to `3.4.1` in the `prometheus` image
* New Java image: remal-java-21-omni-runner. This is a large Docker image with additional Unix tools and packages.
* Improve the documentation
* Improve Kafka configuration to avoid `Replication factor: 3 larger than available brokers: 2.` error.
If you have three or more nodes, you can use the default settings, otherwise you need to customize Kafka. See more details: `KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR` and `KAFKA_TRANSACTION_STATE_LOG_MIN_ISR`
* Change Kafka image from `confluentinc/cp-kafka` to `docker.io/apache/kafka:4.0.0`
* Running Kafka without ZooKeeper in KRaft mode because Kafka is removing ZooKeeper
* Remove `zookeeper`container as we use Kafka 4.0.0 without ZooKeeper in KRaft mode

#### Java projects
* Fix an exception handling problem in the `@MethodStatistics` annotation. Spring's `@ControllerAdvice` annotation did not work properly with custom exception classes. 
* Update Java dependencies
* Change Kafka bootstrap address in `remal-gombi-kafka-consumer` and `remal-gombi-kafka-producer` because we use Kafka 4.0.0 in KRaft mode from now

## [0.5.0] - 26/Feb/2025
#### Java projects
* Add a new tool that can be used to reinject messages to Kafka topic.

## [0.4.0] - 21/Feb/2025
#### Docker Images
* Image for `Hazelcast Platform 5.5.8`

#### Java projects
* Add a new project to demonstrate how the Hazelcast Cache works

## [0.3.0] - 16/Feb/2025
#### Docker Images
* Update `alpine` version from `3.21.0` to `3.21.2` in the `base` image
* Update `EasyRSA` version from `3.2.1` to `3.2.2` in the `easy-rsa-pki` image
* Update `Hashicorp Consul` version from `1.20.1` to `1.20.2` in the `hcp-consul` image
* Update `Hashicorp Vault` version from `1.15.0` to `1.18.4` in the `hcp-vault` image
* Update `Grafana Enterprise` version from `11.4.0` to `11.5.1` in the `grafana` image
* Update `Prometheus` version from `3.0.1` to `3.1.0` in the `prometheus` image
* Fix a bug in the  `gombi.sh`

#### Java projects
* Update dependency: `spring-boot-starter-parent` from version `3.4.1` to `3.4.2`
* Update dependency: `jakarta.servlet-api` from version `1.18.36` to `1.18.36`
* Update dependency: `micrometer` from version `1.14.2` to `1.14.3`
* Update dependency: `spring-boot` from version `3.4.1` to `3.4.2`
* Update dependency: `spring-kafka` from version `3.3.1` to `3.3.2`
* Implementation of `KafkaConsumerController.showReceivedEvents` method

## [0.2.0] - 15/Feb/2025
#### Docker Images
* Add Kafka to the docker stack
* Consolidate the version numbers of the Java projects and Docker images
* Fix a known issue: `Missing User Certificate` issue may appear during the startup of the docker stack in `easy-rsa-pki` container:

#### Java projects
* Add a Kafka message producer demo project
* Add a Kafka message consumer demo project

## [0.1.0] - 15/Jan/2025
#### Docker Images
* Update EasyRSA to version 3.2.1
* Update Hashicorp Consul to version 1.20
* Update Grafana to  version 11.4.0
* Update Prometheus to version 3.0.1
* Improved releasing process: the same image tag is used everywhere
* Improved the way the key and value pairs are imported into the KV store in the `java-21-runner` image
* Fix for parallel EsyRSA execution issue, [#1279](https://github.com/OpenVPN/easy-rsa/issues/1279)
* Fixed missing SAN issue in generated certificate: `failed to verify certificate: x509: certificate relies on legacy Common Name field, use SANs instead`
* Fixed a problem where Grafana did not install the first time the container was launched.
* Fixed a problem where ForgeRock Directory Services did not install the first time the container was launched.
 
#### Java projects
* Maven dependency improvements: use dependency-management
* SSL configuration improvement: use of SSL bundles and better `RestTemplate` configuration
* Update to Spring Boot 3.4.1
* Improved the meters naming in Micrometer

#### Known issues
* `Missing User Certificate` issue may appear during the startup of the docker stack in `easy-rsa-pki` container:
  ~~~
  Write out database with 1 new entries
  Unable to rename /opt/easy-rsa/pki/serial.new to /opt/easy-rsa/pki/serial
  reason: No such file or directory

  Easy-RSA error:

  easyrsa_openssl - Command has failed:
  * openssl ca -utf8 -batch -in /opt/easy-rsa/pki/reqs/kafka-producer-service-1.hello.com.req -out /opt/easy-rsa/pki/55ff927f/temp.5.1 -extfile /opt/easy-rsa/pki/55ff927f/temp.4.1 -passin pass:changeit -days 825
  ~~~
  Solution: Delete the containers and start them again.

## [0.0.1] - 13/Dec/2023
Images and its versions in this release:
* base:0.0.1-remal
* openjdk-11:0.0.1-remal
* openjdk-17:0.0.1-remal
* tomcat-9:0.0.1-remal
* private-ca:0.0.1-remal
* ds-7.3:0.0.1-remal
* am-7.3:0.0.1-remal

<a href="https://trackgit.com">
  <img src="https://us-central1-trackgit-analytics.cloudfunctions.net/token/ping/lcfhkdub7k2lpj33n2cl" alt="trackgit-views" />
</a>
