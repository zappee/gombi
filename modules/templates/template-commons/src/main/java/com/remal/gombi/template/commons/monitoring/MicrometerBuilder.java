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

import java.util.Optional;

@Slf4j
public class MicrometerBuilder {

    private static final String NEW_METER_LOG_TEMPLATE = "creating a new meter: {type: \"{}\", name: \"{}\"}...";

    private final String project;
    private final CompositeMeterRegistry micrometerRegistry;

    public MicrometerBuilder(CompositeMeterRegistry micrometerRegistry, String project) {
        this.project = applyingMicrometerNaming(project);
        this.micrometerRegistry = micrometerRegistry;
    }

    public Counter buildCounter(String meterId) {
        return buildCounter(meterId, null);
    }

    public Counter buildCounter(String meterId, String meterDescription) {
        Type type = Type.COUNTER;
        String name = getName(type, meterId);
        log.debug(NEW_METER_LOG_TEMPLATE, type.getName(), name);

        Optional<String> description = Optional.ofNullable(meterDescription);
        return Counter
                .builder(name)
                .tag("project", project)
                .tag("type", type.getName())
                .description(description.orElse(""))
                .register(micrometerRegistry);
    }

    public Timer buildTimer(String meterId) {
        return buildTimer(meterId, null);
    }

    public Timer buildTimer(String meterId, String meterDescription) {
        Type type = Type.TIMER;
        String name = getName(type, meterId);
        log.debug(NEW_METER_LOG_TEMPLATE, type.getName(), name);

        Optional<String> description = Optional.ofNullable(meterDescription);
        return Timer
                .builder(name)
                .tag("project", project)
                .tag("type", type.getName())
                .description(description.orElse(""))
                .register(micrometerRegistry);
    }

    private String getName(MicrometerBuilder.Type type, String meterId) {
        String id = applyingMicrometerNaming(meterId);
        return switch (type) {
            case COUNTER -> String.format("%s_%s_%s", project, type.getName(), id);
            case TIMER -> String.format("%s_%s_%s_%s", project, type.getName(), id, "milli");
        };
    }

    private String applyingMicrometerNaming(String s) {
        String delimiter = "_";
        return s
                .replaceAll("-", delimiter)
                .replaceAll("\\.", delimiter);
    }

    @Getter
    private enum Type {
        COUNTER("counter"),
        TIMER("timer");

        private final String name;

        Type(String name) {
            this.name = name;
        }
    }
}
