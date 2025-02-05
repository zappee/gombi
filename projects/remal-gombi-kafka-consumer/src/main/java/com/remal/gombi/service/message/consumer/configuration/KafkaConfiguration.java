/*
 *  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  January 2025
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Kafka producer configuration.
 */
package com.remal.gombi.service.message.consumer.configuration;

import com.remal.gombi.commons.model.Event;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.admin.AdminClientConfig;
import org.apache.kafka.clients.admin.NewTopic;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory;
import org.springframework.kafka.config.TopicBuilder;
import org.springframework.kafka.core.ConsumerFactory;
import org.springframework.kafka.core.DefaultKafkaConsumerFactory;
import org.springframework.kafka.core.KafkaAdmin;
import org.springframework.kafka.support.serializer.JsonDeserializer;

import java.util.HashMap;
import java.util.Map;


@Slf4j
@Configuration
@RequiredArgsConstructor
@EnableKafka
public class KafkaConfiguration {

    // producer configuration starts from here

    @Value("${kafka.consumer.auto.offset.reset:latest}")
    private String consumerAutoOffsetReset;

    @Value("${kafka.consumer.batch.listener:false}")
    private boolean consumerBatchListener;

    @Value("${kafka.consumer.bootstrap.servers:kafka-1.hello.com:9092, kafka-2.hello.com:9092}")
    private String consumerBootstrapServers;

    @Value("${kafka.consumer.concurrency:1}")
    private int consumerConcurrency;

    @Value("${kafka.consumer.enable.auto.commit:true}")
    private boolean consumerEnableAutoCommit;

    @Value("${kafka.consumer.log.container.config:false}")
    private boolean consumerLogContainerConfig;

    @Value("${kafka.consumer.missing.topics.fatal:true}")
    private boolean consumerMissingTopicsFatal;

    @Value("${kafka.consumer.poll.timeout:5000}")
    private int consumerPollTimeout;

    // topic configuration starts from here

    @Value("${kafka.topic.name:topic1}")
    private String topicName;

    @Value("${kafka.topic.partitions:1}")
    private int topicPartitions;

    @Value("${kafka.topic.replicas:1}")
    private int topicReplicas;

    /**
     * <PRE>
     * The DefaultKafkaConsumerFactory constructor with three parameters has to
     * be used here because a custom JsonDeserialiser with type info is used.
     *
     * If using the default JsonDeserializer is okay for you, then the Map
     * configuration is safe to use:
     *
     *    configs.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
     *    configs.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, JsonDeserializer.class);
     * </PRE>
     *
     * @return configured ConsumerFactory bean
     */
    @Bean
    public ConsumerFactory<String, Event> consumerFactory() {
        log.debug("initializing ConsumerFactory: {"
                        + "auto.offset.reset: \"{}\", batch.listener: {}, bootstrap.servers: \"{}\", "
                        + "concurrency: {}, enable.auto.commit: {}, log.container.config: {}, "
                        + "missing.topics.fatal: {}, poll.timeout: {}}...",
                consumerAutoOffsetReset,
                consumerBatchListener,
                consumerBootstrapServers,
                consumerConcurrency,
                consumerEnableAutoCommit,
                consumerLogContainerConfig,
                consumerMissingTopicsFatal,
                consumerPollTimeout);

        return new DefaultKafkaConsumerFactory<>(
                consumerConfiguration(),
                new StringDeserializer(),
                new JsonDeserializer<>(Event.class));
    }

    /**
     * <PRE>
     * Why handle messages in batches?
     * To run in the batch mode, we must configure the right batch size by
     * considering the volume of the data published on the topics and the
     * application’s capacity. Moreover, the consumer applications should be
     * designed to handle the messages in bulk to meet the SLAs.
     *
     * Additionally, without batch processing, consumers have to poll regularly
     * on the Kafka topics to get the messages individually. This approach puts
     * pressure on the compute resources. Therefore, batch processing is much
     * more efficient than single message processing per poll.
     *
     * However, batch processing may not be suitable in certain cases where:
     *    - The volume of messages is small
     *    - Immediate processing is critical in time-sensitive application
     *    - There’s a constraint on the compute and memory resources
     *    - Strict message ordering is critical
     * </PRE>
     *
     * @return kafka listener container factory
     */
    @Bean
    public ConcurrentKafkaListenerContainerFactory<String, Event> containerFactory() {
        log.debug("initializing a ConcurrentKafkaListenerContainerFactory...");
        ConcurrentKafkaListenerContainerFactory<String, Event> factory = new ConcurrentKafkaListenerContainerFactory<>();

        // Set to true if this endpoint should create a batch listener.
        factory.setBatchListener(consumerBatchListener);

        // The maximum number of concurrent KafkaMessageListenerContainers running.
        // Use cases:
        //    - You have a topic with three partitions and setConcurrency(1) is used: Spring creates
        //      only one consumer thread, all the partitions are read by the same consumer thread.
        //
        //    - You have a topic with three partitions and setConcurrency(3) is used: Spring creates
        //      three Java consumer threads and each unique thread connects to a specific partition.
        //
        //    - You have a topic with three partitions and setConcurrency(4) is used: Spring creates
        //      three Java consumer threads, connected to the three partitions. One Java thread is idle.
        //
        // Messages only from the same partition are processed sequentially. There will be no order guarantee
        // unless you use exactly one partition. More specifically, data is only ordered within a partition.
        // If you want to process the incoming data sequentially, then you
        //    1) need to have only one partition per topic
        //    2) use the Hashing-Key technique
        factory.setConcurrency(consumerConcurrency);

        // When true and INFO logging is enabled each listener container writes a log
        // message summarizing its configuration properties.
        factory.getContainerProperties().setLogContainerConfig(consumerLogContainerConfig);

        // Set to false to allow the container to start even if any of the configured topics are not present
        // on the broker. Default true;
        factory.getContainerProperties().setMissingTopicsFatal(consumerMissingTopicsFatal);

        // Specify a ConsumerFactory to use.
        factory.setConsumerFactory(consumerFactory());

        // Set the max time to block in the consumer waiting for records.
        factory.getContainerProperties().setPollTimeout(consumerPollTimeout);

        return factory;
    }

    /**
     * When using Spring Boot, a KafkaAdmin bean is automatically registered so
     * you only need the NewTopic @Beans. But if you use NewTopic and custom
     * producer config, you need to use that custom config for KafkaAdmin as
     * well.
     *
     * @return custom KafkaAdmin instance
     */
    @Bean
    public KafkaAdmin admin() {
        log.debug("initializing a KafkaAdmin: {bootstrap.servers: \"{}\"}...", consumerBootstrapServers);
        Map<String, Object> configs = new HashMap<>();
        configs.put(AdminClientConfig.BOOTSTRAP_SERVERS_CONFIG, consumerBootstrapServers);
        return new KafkaAdmin(configs);
    }

    /**
     * Topic creation.
     *
     * @return the created new topic
     */
    @Bean
    public NewTopic topic() {
        log.debug(
                "creating a new kafka topic: {name: \"{}\", partitions: {}, replicas: {}}",
                topicName,
                topicPartitions,
                topicReplicas);

        return TopicBuilder
                .name(topicName)
                .partitions(topicPartitions)
                .replicas(topicReplicas)
                .build();
    }

    private Map<String, Object> consumerConfiguration() {
        Map<String, Object> configs = new HashMap<>();

        // default:	latest
        // valid values: [latest, earliest, none]
        //
        // What to do when there is no initial offset in Kafka or if the current offset does not exist any more
        // on the server (e.g. because that data has been deleted):
        //
        //    - earliest: automatically reset the offset to the earliest offset
        //    - latest: automatically reset the offset to the latest offset
        //    - none: throw exception to the consumer if no previous offset is found for the consumer’s group
        //    - anything else: throw exception to the consumer.
        //
        // Note that altering partition numbers while setting this config to latest may cause message delivery
        // loss since producers could start to send messages to newly added partitions (i.e. no initial offsets
        // exist yet) before consumers reset their offsets.
        configs.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");

        // default: null
        configs.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, consumerBootstrapServers);

        // default: true
        //
        // If true the consumer’s offset will be periodically committed in the background.
        configs.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, "false");

        return configs;
    }
}
