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
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.errors.RetriableException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.stereotype.Component;

import java.util.concurrent.CompletableFuture;

@Slf4j
@Component
public class KafkaProducerService {

    @Getter
    @Value("${kafka.topic.name}")
    private String kafkaTopic;

    private final KafkaTemplate<String, Event> kafkaTemplate;

    public KafkaProducerService(KafkaTemplate<String, Event> kafkaTemplate) {
        this.kafkaTemplate = kafkaTemplate;
    }

    public void onSend(Event event) {
        try {
            log.debug("sending message to kafka: {topic: \"{}\", payload: {}}", kafkaTopic, event);

            // Why are all producer messages sent to one partition?
            // If you are not specifying any custom partition it will use the default partitioner
            // as per the below rule:
            //
            //   1) If a partition is specified in the record, use it that partition to publish.
            //
            //   2) If no partition is specified but a key is present choose a partition based on
            //      a hash of the key
            //
            //   3) If no partition or key is present choose a partition in a round-robin fashion
            ProducerRecord<String, Event> record = new ProducerRecord<>(kafkaTopic, event);

            CompletableFuture<SendResult<String, Event>> future = kafkaTemplate.send(record);
            future.
                    whenComplete((result, ex) -> {
                        if (ex == null) {
                            log.info(
                                    "message has been sent to Kafka successfully: {topic: \"{}\", partition: {}, offset: {}, key: \"{}\", value: \"{}\"}",
                                    result.getRecordMetadata().topic(),
                                    result.getRecordMetadata().partition(),
                                    result.getRecordMetadata().offset(),
                                    result.getProducerRecord().key(),
                                    result.getProducerRecord().value());
                        } else {
                            log.error(
                                    "an unexpected error has occurred while sending message to Kafka: {topic: \"{}\", payload: {}, error: {}}",
                                    result.getRecordMetadata().topic(),
                                    event.toString(),
                                    ex.getCause().getMessage(),
                                    ex);
                        }})
                    .exceptionally(ex -> {
                                log.error("Sending message to kafka has been finished with an error.", ex);
                                return null;
                    });
        } catch (Throwable ex) {
            if (ex.getCause() instanceof RetriableException) {
                log.error(
                        "A retryable error has been appeared while sending message to kafka: {topic: \"{}\", event: {}}",
                        kafkaTopic,
                        event.toString(),
                        ex);
            } else {
                log.error(
                        "A non-retryable error has been appeared while sending message to kafka: {topic: \"{}\", event: {}}",
                        kafkaTopic,
                        event.toString(),
                        ex);
            }
        } finally {
            // // important to use when setProducerPerThread(true) is set
            //factory.closeThreadBoundProducer();
        }
    }
}
