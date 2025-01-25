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
import org.springframework.web.bind.annotation.*;
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
    public String sendDefaultMessageToKafka() {
        var event = Event.builder().
                source("payment-service").
                owner("arnold").
                payload("{\"reason\": \"test event from the GET rest endpoint\"}")
                .build();
        kafkaProducer.onSend(event);
        return "A new test message has been sent to Kafka topic.";
    }

    @PostMapping("/send")
    @MethodStatistics
    public String sendCustomMessageToKafka(@RequestBody Event event) {
        kafkaProducer.onSend(event);
        return "A new message has been sent to Kafka topic.";
    }
}
