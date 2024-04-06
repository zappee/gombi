/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  April 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Application monitoring with Micrometer. This service defines the
 *     Micrometer Meter definitions. A meter is uniquely identified by
 *     its name and dimensions.
 */
package com.remal.gombi.template.service.hello.service;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.stereotype.Service;

@Service
public class MicrometerService {

    private final MeterRegistry meterRegistry;

    public MicrometerService(MeterRegistry meterRegistry) {
        this.meterRegistry = meterRegistry;
    }

    public Counter getUsernameConfigirationCounter() {
        return meterRegistry.counter("helloservice_config_user_username_count");
    }

    public Counter getdescriptionConfigirationCounter() {
        return meterRegistry.counter("helloservice_config_user_description_count");
    }
}
