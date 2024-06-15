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

import com.remal.gombi.hello.service.echo.micrometer.MicrometerBuilder;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.stereotype.Component;

@Component
@RefreshScope
@Slf4j
public class ConfigurationService {

    public static final String ACCESS_LOG_TEMPLATE = "value from the kv store: {{}: \"{}\"}";
    private final MicrometerBuilder micrometerBuilder;


    @Value("${description.option.a}")
    private String optionA;

    @Value("${description.option.b}")
    private String optionB;

    public ConfigurationService(MicrometerBuilder micrometerBuilder) {
        this.micrometerBuilder = micrometerBuilder;
    }

    public String getOptionA() {
        logAccess("kv.description.option.a");
        return optionA;
    }

    public String getOptionB() {
        logAccess("kv.description.option.b");
        return optionB;
    }

    private void logAccess(String id) {
        log.debug(ACCESS_LOG_TEMPLATE, id, optionB);
        micrometerBuilder.getCounter(id).increment();
    }
}
