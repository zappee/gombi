/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  April 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     This a Spring-Bean with RefreshScope that allows for beans to be
 *     refreshed dynamically at runtime. If a bean is refreshed then the next
 *     time the bean is accessed (i.e. a method is executed) a new instance is
 *     created.
 *     Beans with @RefreshScope feature will be dynamically updated when a
 *     value in the Hashicorp Consul KV store has changed. This configuration
 *     keeps up-to-date the configuration values without restarting the spring
 *     boot application.
 */
package com.remal.gombi.hello.service.echo.service;

import com.remal.gombi.hello.commons.spring.monitoring.MicrometerBuilder;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.stereotype.Component;

@Component
@RefreshScope
@Slf4j
public class ConfigurationService {

    @Value("${user.username}")
    private String username;

    @Value("${user.description}")
    private String description;

    public String getUsername() {
        String key = "user.username";
        log.debug(MicrometerBuilder.CLOUD_CONFIG_ACCESS_LOG_TEMPLATE, key, username);
        MicrometerBuilder.getCloudConfigAccessMeter(key).increment();
        return username;
    }

    public String getDescription() {
        String key = "user.description";
        log.debug(MicrometerBuilder.CLOUD_CONFIG_ACCESS_LOG_TEMPLATE, key, username);
        MicrometerBuilder.getCloudConfigAccessMeter(key).increment();
        return description;
    }
}
