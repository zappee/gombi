/*
 *  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  January 2025
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Spring REST endpoint.
 */
package com.remal.gombi.service.message.producer.controller;

import com.remal.gombi.commons.model.Event;
import com.remal.gombi.commons.monitoring.MethodStatistics;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.remal.gombi.service.message.producer.service.KafkaProducerService;

@Slf4j
@RestController
@RequestMapping("/api/kafka")
public class KafkaProducerController {

    private final KafkaProducerService kafkaProducer;

    public KafkaProducerController(KafkaProducerService kafkaProducer) {
        this.kafkaProducer = kafkaProducer;
    }

    @GetMapping("/send")
    @MethodStatistics
    public String sendMessageToKafka() {
        var event = Event.builder().source("payment-service").owner("arnold").payload("{}").build();
        kafkaProducer.sendEvent(event);
        return "Message has been sent to Kafka topic.";
    }
}
