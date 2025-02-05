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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;
import java.util.Random;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.IntStream;

@Slf4j
@RestController
@RequestMapping("/api/kafka")
public class KafkaProducerController {

    private final KafkaProducerService kafkaProducer;

    public KafkaProducerController(KafkaProducerService kafkaProducer) {
        this.kafkaProducer = kafkaProducer;
    }

    /**
     *  Sends a new message to the Kafka queue with the given user-id.
     *
     * @param usedId user-id string
     * @return report of the sending
     */
    @GetMapping("/send-one/{usedId}")
    @MethodStatistics
    public String sendOneMessage(@PathVariable("usedId") String usedId) {
        var event = Event.builder()
                .sourceSystem("x-service")
                .userId(usedId)
                .payload(String.format("{\"index\": \"%s\"}", usedId))
                .build();
        kafkaProducer.onSend(event);
        return String.format("A new message has been sent to the <b>%s</b> Kafka topic. User-id: <b>%s</b>",
                kafkaProducer.getKafkaTopic(), usedId);
    }

    /**
     * This endpoint demonstrates how messages can be produced using the hashing key technique, while the
     * consumer maintains the order of the messages. SQL to get the messages on the consumer side:
     * select * EVENT where USER_ID = '3' order by ID
     *
     * @param numberOfMessages the number to message to be sent in the same batch
     * @return report of the sending
     */
    @GetMapping("/send-multiple/{numberOfMessages}")
    @MethodStatistics
    public String sendMultipleMessages(@PathVariable("numberOfMessages") int numberOfMessages) {
        record User(Integer id, String name, AtomicInteger counter) {}
        var users = Map.of(
                1, new User(1, "Alex", new AtomicInteger()),
                2, new User(2, "Dorothy", new AtomicInteger()),
                3, new User(3, "Felix", new AtomicInteger()),
                4, new User(4, "Henry", new AtomicInteger()),
                5, new User(5, "Juliet", new AtomicInteger()),
                6, new User(6, "Lucy", new AtomicInteger()),
                7, new User(7, "Oliver", new AtomicInteger()),
                8, new User(8, "Peggy", new AtomicInteger()),
                9, new User(9, "Robert", new AtomicInteger()),
                10, new User(10, "Selena", new AtomicInteger()));
        var random = new Random();

        IntStream.range(1, numberOfMessages + 1).forEach( messageIndex -> {
            var userIndex = random.nextInt(users.size()) + 1;
            var user = users.get(userIndex);
            var event = Event.builder()
                    .sourceSystem("x-service")
                    .userId(String.valueOf(user.id))
                    .payload(String.format("{\"name\": \"%s\", index: %s}", user.name, user.counter.incrementAndGet()))
                    .build();
            kafkaProducer.onSend(event);
        });
        return String.format("<b>%s</b> messages has been sent to the <b>%s</b> Kafka topic.",
                numberOfMessages, kafkaProducer.getKafkaTopic());
    }

    /**
     * This method accepts only JSON request body.
     *
     * @param event JSON representation of the Event
     * @return response
     */
    @PostMapping("/send")
    @MethodStatistics
    public String sendCustomMessage(@RequestBody Event event) {
        kafkaProducer.onSend(event);
        return "A message has been sent to the <b>" + kafkaProducer.getKafkaTopic() + "</b> Kafka topic.";
    }
}
