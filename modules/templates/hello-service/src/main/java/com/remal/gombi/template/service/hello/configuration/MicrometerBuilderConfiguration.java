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
public class MicrometerBuilderConfiguration {

    private final BuildProperties buildProperties;
    private final CompositeMeterRegistry meterRegistry;

    public MicrometerBuilderConfiguration(BuildProperties buildProperties, CompositeMeterRegistry meterRegistry) {
        this.buildProperties = buildProperties;
        this.meterRegistry = meterRegistry;
    }

    @Bean
    public MicrometerBuilder buildMicrometerBuilder() {
        return new MicrometerBuilder(meterRegistry, buildProperties.getName());
    }
}
