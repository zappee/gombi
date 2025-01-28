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
import com.remal.gombi.service.message.consumer.error.KafkaConsumerErrorHandler;
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
import java.util.Objects;


@Slf4j
@Configuration
@RequiredArgsConstructor
@EnableKafka
public class KafkaConfiguration {

    @Value("${kafka.producer.bootstrap.servers:kafka-1.hello.com:9092, kafka-2.hello.com:9092}")
    private String kafkaBootstrapServers;


    @Value("${kafka.topic.name:topic1}")
    private String kafkaTopicName;

    @Value("${kafka.topic.partitions:1}")
    private int kafkaTopicPartitions;

    @Value("${kafka.topic.replicas:1}")
    private int kafkaTopicReplicas;

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
    public ConcurrentKafkaListenerContainerFactory<String, Event> consumerFactory() {
        ConcurrentKafkaListenerContainerFactory<String, Event> factory = new ConcurrentKafkaListenerContainerFactory<>();

        // Specify a ConsumerFactory to use.
        factory.setConsumerFactory(consumerConfigs());

        // The maximum number of concurrent KafkaMessageListenerContainers running.
        // Messages from within the same partition will be processed sequentially.
        factory.setConcurrency(3);

        // Set the max time to block in the consumer waiting for records.
        factory.getContainerProperties().setPollTimeout(3000);

        // Set to true if this endpoint should create a batch listener.
        factory.setBatchListener(false);

        // Set the CommonErrorHandler which can handle errors for both record and batch listeners.
        factory.setCommonErrorHandler(new KafkaConsumerErrorHandler());

        return factory;
    }

    /**
     * Kafka configuration.
     *
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
    public ConsumerFactory<String, Event> consumerConfigs() {
        ConsumerFactory<String, Event> factory = new DefaultKafkaConsumerFactory<>(
                consumerConfiguration(),
                new StringDeserializer(),
                new JsonDeserializer<>(Event.class));

        log.debug("initializing a ConsumerFactory using the following setting: {{}}", factoryConfigurationToString(factory));
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
        Map<String, Object> configs = new HashMap<>();
        configs.put(AdminClientConfig.BOOTSTRAP_SERVERS_CONFIG, kafkaBootstrapServers);
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
                kafkaTopicName,
                kafkaTopicPartitions,
                kafkaTopicReplicas);

        return TopicBuilder.name(kafkaTopicName)
                .partitions(kafkaTopicPartitions)
                .replicas(kafkaTopicReplicas)
                .build();
    }

    private Map<String, Object> consumerConfiguration() {
        Map<String, Object> configs = new HashMap<>();
        configs.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, kafkaBootstrapServers);

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

        // default: true
        //
         // If true the consumer’s offset will be periodically committed in the background.
        configs.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, "false");
        return configs;
    }

    /**
     * Used for logging purposes only.
     *
     * @param consumerFactory the factory used bz the message consumer
     * @return factory configuration in human-readable format
     */
    private String factoryConfigurationToString(ConsumerFactory<String, Event> consumerFactory) {
        var keyDeserializer = consumerFactory.getKeyDeserializer();
        var keyDeserializerAsString = Objects.isNull(keyDeserializer) ? "null" : keyDeserializer.getClass().getName();

        var valueDeserializer = consumerFactory.getValueDeserializer();
        var valueDeserializerAsString = Objects.isNull(valueDeserializer) ? "null" : valueDeserializer.getClass().getName();

        var sb = new StringBuilder().append("configuration: ").append("{");
        consumerFactory.
                getConfigurationProperties().
                forEach((key, value) -> sb.append(String.format("\"%s\": \"%s\", ", key, value)));

        sb.setLength(sb.length() - 2);
        sb.append("}, ");
        sb.append("key-serializer: ").append(keyDeserializerAsString).append(", ");
        sb.append("value-serializer: ").append(valueDeserializerAsString);
        return sb.toString();
    }
}
