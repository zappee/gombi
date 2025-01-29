/*
 *  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  January 2025
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Spring REST endpoint.
 */
package com.remal.gombi.service.message.consumer.service;

import com.remal.gombi.commons.exception.FailureToProcessException;
import com.remal.gombi.commons.model.Event;
import com.remal.gombi.service.message.consumer.mapper.EventMapper;
import com.remal.gombi.service.message.consumer.repository.EventRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.consumer.Consumer;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class KafkaConsumerService {

    private final EventRepository eventRepository;
    private final EventMapper eventMapper;

    @KafkaListener(
            id = "${kafka.topic.name}-id",
            topics = "${kafka.topic.name}",
            groupId = "${random.uuid}",
            containerFactory = "consumerFactory")
    public void onConsume(ConsumerRecord<String, Event> data, Consumer<?, ?> consumer) {
        var topic = data.topic();
        var partition = data.partition();
        var groupId = consumer.groupMetadata().groupId();
        var payload = data.value();

        log.debug(
                "receiving a message from kafka: {topic: \"{}\", partition: {}, group-id: \"{}\", payload: {}}",
                topic,
                partition,
                groupId,
                payload.toString());

        var eventEntity = eventMapper.toEntity(payload);
        eventEntity.setTopic(topic);
        eventEntity.setPartition(partition);
        eventEntity.setGroupId(groupId);

        eventRepository.save(eventEntity);

        // a deliberately thrown error for testing purposes
        if (payload.getOwner().equals("error")) {
            throw new FailureToProcessException(payload, topic, "A deliberately thrown error for testing purposes.");
        }
     }
}
