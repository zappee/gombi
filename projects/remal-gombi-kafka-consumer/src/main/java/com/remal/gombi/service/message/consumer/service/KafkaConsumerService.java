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
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.consumer.Consumer;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Component
@RequiredArgsConstructor
public class KafkaConsumerService {

    @Getter
    @Value("${kafka.topic.name}")
    private String topicName;

    private final EventRepository eventRepository;
    private final EventMapper eventMapper;
    private final MicrometerMeterService meterService;

    @KafkaListener(
            // Think of it as the name of the bean, used only internally by Spring.
            // When provided, this value will override the group id property in the consumer
            // factory configuration, unless idIsGroup() is set to false or groupId() is provided.
            //id = "kafkaListener",

            // This is used to generate the Consumer ID of the spring consumer.
            // Consumers read the messages from a partition to be assigned to the consumer. Setting
            // this correctly will help you to identify in a monitoring system to see who is
            // consuming the partition.
            // TThe $FQDN here is an environment variable; its value reflects the full qualified
            // domain name of the host machine on which the consumer is running.
            clientIdPrefix = "${FQDN}",

            // Used by kafka broker to uniquely identify a consumer group.
            groupId = "${kafka.topic.name}-${random.uuid}",

            topics = "${kafka.topic.name}",
            containerFactory = "containerFactory")

    // The trick here is giving transactionManager as the value for the @Transactional annotation because
    // there are two transaction manager beans available: transactionManager and kafkaTransactionManager.
    // The transactionManager is an instance of JpaTransactionManager while the kafkaTransactionManager
    // bean is an instance of KafkaTransactionManager.
    // Whenever a new message comes in, it will automatically begin a kafka transaction before it starts
    // running our method.
    @Transactional("transactionManager")
    public void onMessage(ConsumerRecord<String, Event> data, Consumer<?, ?> consumer) {
        var topic = data.topic();
        var partition = data.partition();
        var groupId = consumer.groupMetadata().groupId();
        var consumerId = consumer.groupMetadata().memberId();
        var payload = data.value();

        log.debug(
                "receiving a message from kafka: {topic: \"{}\", partition: {}, consumer-group: \"{}\", consumer-id-in-the-group:  \"{}\", payload: {}}",
                topic,
                partition,
                groupId,
                consumerId,
                payload.toString());
        meterService.registerReceivedEvent();

        var eventEntity = eventMapper.toEntity(payload);
        eventEntity.setTopic(topic);
        eventEntity.setPartition(partition);
        eventEntity.setGroupId(groupId);

        eventRepository.save(eventEntity);

        // a deliberately thrown error for testing purposes
        if (payload.getUserId().equals("error")) {
            throw new FailureToProcessException(payload, topic, "A deliberately thrown error for testing purposes.");
        }

        meterService.registerProcessedEvent();
     }
}
