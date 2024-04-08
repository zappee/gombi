/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  April 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Micrometer ID generator. The IDs are used by Micrometer and Prometheus to
 *     help collecting and filter metrics.
 */
package com.remal.gombi.template.commons.monitoring;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.Timer;
import io.micrometer.core.instrument.composite.CompositeMeterRegistry;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class MicrometerBuilder {

    private static final String NEW_METER_LOG_TEMPLATE = "creating a new meter: {type: \"{}\", name: \"{}\"}...";

    private final String project;
    private final CompositeMeterRegistry micrometerRegistry;

    public MicrometerBuilder(CompositeMeterRegistry micrometerRegistry, String project) {
        this.project = project;
        this.micrometerRegistry = micrometerRegistry;
    }

    public Timer getMeasureExecutionTimeMeter(String meterId) {
        return buildTimer(Type.EXECUTION_TIME, meterId, "Execution time of the method");
    }

    public Counter getAccessToConfigKeyMeter(String meterId) {
        return buildCounter(Type.CONFIG_KEY, meterId, "Number of access to the configuration key");
    }

    private Counter buildCounter(Type type, String meterId, String meterDescription) {
        String name = getName(type, meterId);
        logAccess(type, name);
        return Counter
                .builder(name)
                .tag("project", project)
                .tag("type", type.getName())
                .description(meterDescription)
                .register(micrometerRegistry);
    }

    private Timer buildTimer(Type type, String meterId, String meterDescription) {
        String name = getName(type, meterId);
        logAccess(type, name);
        return Timer
                .builder(name)
                .tag("project", project)
                .tag("type", type.getName())
                .description(meterDescription)
                .register(micrometerRegistry);
    }

    private static void logAccess(Type type, String name) {
        log.debug(NEW_METER_LOG_TEMPLATE, type.getName(), name);
    }

    private String getName(MicrometerBuilder.Type type, String meterId) {
        return String.format("%s_%s_%s", project, type.getName(), meterId);
    }

    @Getter
    private enum Type {
        EXECUTION_TIME("execution_time"),
        CONFIG_KEY("config");

        private final String name;

        Type(String name) {
            this.name = name;
        }
    }
}
