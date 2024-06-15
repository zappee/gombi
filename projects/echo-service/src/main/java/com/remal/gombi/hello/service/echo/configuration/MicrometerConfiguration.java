/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  April 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Application monitoring with Micrometer.
 */
package com.remal.gombi.hello.service.echo.configuration;

import com.remal.gombi.hello.commons.Internet;
import io.micrometer.core.instrument.Metrics;
import io.micrometer.core.instrument.composite.CompositeMeterRegistry;
import org.springframework.boot.info.BuildProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@ComponentScan("com.remal.gombi.hello.commons.monitoring")
public class MicrometerConfiguration {

    private final BuildProperties buildProperties;

    public MicrometerConfiguration(BuildProperties buildProperties) {
        this.buildProperties = buildProperties;
    }

    @Bean
    public CompositeMeterRegistry buildMeterRegistry() {
        CompositeMeterRegistry registry = new CompositeMeterRegistry();
        registry.config().commonTags("project", buildProperties.getName());
        registry.config().commonTags("host", Internet.getHostname());
        Metrics.addRegistry(registry);
        return registry;
    }
}
