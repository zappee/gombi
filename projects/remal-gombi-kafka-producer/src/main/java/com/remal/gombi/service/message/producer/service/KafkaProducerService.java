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
import org.springframework.stereotype.Component;

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
        kafkaTemplate.send(record).
                whenComplete((result, ex) -> {
                    if (ex == null) {
                        log.info(
                                "message successfully sent to kafka: {topic: \"{}\", partition: {}, offset: {}, key: \"{}\", value: \"{}\"}",
                                result.getRecordMetadata().topic(),
                                result.getRecordMetadata().partition(),
                                result.getRecordMetadata().offset(),
                                result.getProducerRecord().key(),
                                result.getProducerRecord().value());
                    } else {
                        // If Spring is unable to deliver the message to the kafka topic within the time specified
                        // in 'delivery.timeout.ms' (ProducerConfig.DELIVERY_TIMEOUT_MS_CONFIG), Spring
                        // throws an exception.
                        var cause = ex.getCause();
                        var isRetryable = cause instanceof RetriableException;
                        log.error(
                                "failed to send message to kafka: {topic: \"{}\", event: {}, error: {}, isRetryable: {}}",
                                kafkaTopic,
                                event.toString(),
                                cause.getMessage(),
                                isRetryable,
                                ex);
                    }});
    }
}
