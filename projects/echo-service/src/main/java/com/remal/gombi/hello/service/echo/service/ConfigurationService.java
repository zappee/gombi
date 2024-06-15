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

import com.remal.gombi.hello.commons.monitoring.MethodStatistics;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.stereotype.Component;

@Component
@RefreshScope
@Slf4j
public class ConfigurationService {

    @Value("${description.option.a}")
    private String optionA;

    @Value("${description.option.b}")
    private String optionB;

    @MethodStatistics(logToLogfile = false)
    public String getOptionA() {
        return optionA;
    }

    @MethodStatistics(logToLogfile = false)
    public String getOptionB() {
        return optionB;
    }
}
