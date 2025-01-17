/*
 *  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  January 2025
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Spring REST endpoint.
 */
package com.remal.gombi.service.message.producer.service;

import com.remal.gombi.commons.model.Event;
import com.remal.gombi.service.message.producer.configuration.KafkaProducerConfiguration;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.stereotype.Component;

import java.util.concurrent.CompletableFuture;

@Slf4j
@Component
public class KafkaProducerService {

    private final KafkaTemplate<String, Event> kafkaTemplate;

    public KafkaProducerService(KafkaTemplate<String, Event> kafkaTemplate) {
        this.kafkaTemplate = kafkaTemplate;
    }

    public void sendEvent(Event event) {
        log.debug("sending message to kafka: {topic: \"{}\", payload: {}}", kafkaTemplate.getDefaultTopic(), event);

        CompletableFuture<SendResult<String, Event>> future = kafkaTemplate.send(KafkaProducerConfiguration.KAFKA_TOPIC, event);
        future.whenComplete((result, ex) -> {
            if (ex == null) {
                log.info("message has been sent to Kafka successfully: {}", result.toString());
            } else {
                log.error(
                        "an unexpected error has occurred while sending message to Kafka: {topic: \"{}\", payload: {}, error: {}}",
                        result.getRecordMetadata().topic(),
                        event.toString(),
                        ex.getMessage());
            }
        });
    }
}
