# Remal Image: ForgeRock Access Management

### 1) Overview
This is a Remal Docker image for ForgeRock Access Management , using [openjdk-11](../../tomcat/openjdk-11/README.md) as a base image.

### 2) Ports used by the image

| container port | description              |
|----------------|--------------------------|
| 22             | SSH                      |
| 8080           | Apache Tomcat HTTP port  |
| 443            | Apache Tomcat HTTPs port |

Tomcat web console user:
* account: `admin`/`password`

Access Management admin user:
* account: `amAdmin`/`password`
* OpenAM web console: [https://am.remal.com:13024/openam]()

## 3) Troubleshooting
* Turn on SSL debug log: `-Djavax.net.debug=all`

## 4) License and Copyright
Copyright (c) 2020-2024 Remal Software, Arnold Somogyi. All rights reserved.
