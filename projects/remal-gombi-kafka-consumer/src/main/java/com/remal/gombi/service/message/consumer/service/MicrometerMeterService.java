/*
 *  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  February 2025
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Pre configured micrometer meters.
 */
package com.remal.gombi.service.message.consumer.service;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.composite.CompositeMeterRegistry;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class MicrometerMeterService {

    @Getter
    @Value("${kafka.topic.name}")
    private String topicName;

    private final CompositeMeterRegistry meterRegistry;

    public void registerIncomingEvent() {
        getCounter("received", "Total number of received messages from kafka topic.").increment();
    }

    public void registerProcessedEvent() {
        getCounter("processed", "Total number of the processed messages.").increment();
    }

    public void registerDroppedEvent() {
        getCounter("dropped", "Total number of dropped messages.").increment();
    }

    private Counter getCounter(String status, String description) {
        return Counter
                .builder("remal_kafka_consumer_" + topicName)
                .tags("topic", topicName, "status", status)
                .description(description)
                .register(meterRegistry);
    }
}
