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
import com.remal.gombi.service.message.producer.service.KafkaProducerService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.stream.IntStream;

@Slf4j
@RestController
@RequestMapping("/api/kafka")
public class KafkaProducerController {

    private final KafkaProducerService kafkaProducer;

    public KafkaProducerController(KafkaProducerService kafkaProducer) {
        this.kafkaProducer = kafkaProducer;
    }

    @GetMapping("/send-one")
    @MethodStatistics
    public String sendOneMessage() {
        var event = Event.builder().
                source("payment-service").
                owner("amelia").
                payload("{\"comment\": \"default message\"}")
                .build();
        kafkaProducer.onSend(event);
        return "A message has been sent to the <b>" + kafkaProducer.getKafkaTopic() + "</b> Kafka topic.";
    }

    @GetMapping("/send-multiple")
    @MethodStatistics
    public String sendMultipleMessages() {
        var numberOfMessages = 10;

        IntStream.range(1, numberOfMessages + 1).forEach( index -> {
            var event = Event.builder().
                    source("payment-service").
                    owner("amelia").
                    payload(String.format("{\"comment\": \"%s. message\"}", index))
                    .build();
            kafkaProducer.onSend(event);
        });
        return numberOfMessages + " messages has been sent to the <b>" + kafkaProducer.getKafkaTopic() + "</b> Kafka topic.";
    }

    @PostMapping("/send")
    @MethodStatistics
    public String sendCustomMessage(@RequestBody Event event) {
        kafkaProducer.onSend(event);
        return "A message has been sent to the <b>" + kafkaProducer.getKafkaTopic() + "</b> Kafka topic.";
    }
}
