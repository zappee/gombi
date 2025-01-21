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
    public void onMessage(ConsumerRecord<String, Event> data, Consumer<?, ?> consumer) {
        log.debug(
                "receiving a message from kafka: {topic: \"{}\", group-id: \"{}\", partition: {}, payload: {}}",
                data.topic(),
                consumer.groupMetadata().groupId(),
                data.partition(),
                data.value().toString());
        var eventEntity = eventMapper.toEntity(data.value());
        eventRepository.save(eventEntity);
     }
}
