# Release info

All notable changes to this project will be documented in this file.

## [0.2.0] - 15/Feb/2025
### Docker Images
* Add Kafka to the docker stack

### Java projects
* Add kafka producer and consumer sample projects

## [0.1.0] - 15/Jan/2025
### Docker Images
* Update EasyRSA to version 3.2.1
* Update Hashicorp Consul to version 1.20
* Update Grafana to  version 11.4.0
* Update Prometheus to version 3.0.1
* Improved releasing process: the same image tag is used everywhere
* Improved the way the key and value pairs are imported into the KV store in the `java-21-runner' image
* Fix for parallel EsyRSA execution issue, [#1279](https://github.com/OpenVPN/easy-rsa/issues/1279)
* Fixed missing SAN issue in generated certificate: `failed to verify certificate: x509: certificate relies on legacy Common Name field, use SANs instead`
* Fixed a problem where Grafana did not install the first time the container was launched.
* Fixed a problem where ForgeRock Directory Services did not install the first time the container was launched.
 
### Java projects
* Maven dependency improvements: use dependency-management
* SSL configuration improvement: use of SSL bundles and better `RestTemplate` configuration
* Update to Spring Boot 3.4.1
* Improved the meters naming in Micrometer

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
