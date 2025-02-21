/*
 *  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  February 2025
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Pre configured micrometer meters.
 */
package com.remal.gombi.service.counter.service;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.composite.CompositeMeterRegistry;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class MicrometerMeterService {

    private final CompositeMeterRegistry meterRegistry;

    public void registerMapCacheEvent(String mapId, String event) {
        var counter = Counter
                .builder("remal_hazelcast")
                .tags("map-id", mapId, "event", event)
                .description("Hazelcast cache events")
                .register(meterRegistry);
        counter.increment();
    }
}
