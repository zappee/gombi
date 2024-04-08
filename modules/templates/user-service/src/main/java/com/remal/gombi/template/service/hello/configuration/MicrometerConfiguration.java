/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  April 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Application monitoring with Micrometer.
 */
package com.remal.gombi.template.service.hello.configuration;

import com.remal.gombi.template.commons.monitoring.MicrometerBuilder;
import io.micrometer.core.instrument.composite.CompositeMeterRegistry;
import org.springframework.boot.info.BuildProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MicrometerConfiguration {

    private final BuildProperties buildProperties;

    public MicrometerConfiguration(BuildProperties buildProperties) {
        this.buildProperties = buildProperties;
    }

    @Bean
    public MicrometerBuilder createMicrometerId() {
        return new MicrometerBuilder(createMircometerRegistry(), buildProperties.getName());
    }

    @Bean
    protected CompositeMeterRegistry createMircometerRegistry() {
        return new CompositeMeterRegistry();
    }
}
