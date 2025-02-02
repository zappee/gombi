/*
 *  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  January 2025
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Kafka producer configuration.
 */
package com.remal.gombi.service.message.producer.configuration;

import com.remal.gombi.commons.model.Event;
import jakarta.annotation.Nonnull;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.admin.AdminClientConfig;
import org.apache.kafka.clients.admin.NewTopic;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringSerializer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.config.TopicBuilder;
import org.springframework.kafka.core.DefaultKafkaProducerFactory;
import org.springframework.kafka.core.KafkaAdmin;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.core.ProducerFactory;
import org.springframework.kafka.core.ProducerPostProcessor;
import org.springframework.kafka.support.serializer.JsonSerializer;
import org.springframework.lang.NonNull;

import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;


@Slf4j
@Configuration
@RequiredArgsConstructor
@EnableKafka
public class KafkaConfiguration {

    @Value("${kafka.producer.bootstrap.servers:kafka-1.hello.com:9092, kafka-2.hello.com:9092}")
    private String kafkaBootstrapServers;

    @Value("${kafka.producer.enable.idempotence:true}")
    private String kafkaProducerEnableIdempotence;

    @Value("${kafka.producer.acks:all}")
    private String kafkaProducerAcks;

    @Value("${kafka.producer.retries:2147483647}")
    private String kafkaProducerRetries;

    @Value("${kafka.producer.linger.ms:0}")
    private String kafkaProducerLingerMs;

    @Value("${kafka.producer.delivery.timeout.ms:120000}")
    private String kafkaProducerDeliveryTimeoutMs;

    @Value("${kafka.producer.request.timeout.ms:30000}")
    private String kafkaProducerRequestTimeoutMs;

    @Value("${kafka.producer.retry.backoff.ms:100}")
    private String kafkaProducerRetryBackoffMs;

    @Value("${kafka.producer.retry.backoff.max.ms:1000}")
    private String kafkaProducerRetryBackoffMaxMs;


    @Value("${kafka.topic.name:topic1}")
    private String kafkaTopicName;

    @Value("${kafka.topic.partitions:1}")
    private int kafkaTopicPartitions;

    @Value("${kafka.topic.replicas:1}")
    private int kafkaTopicReplicas;

    /**
     * Kafka configuration.
     *
     * @return configured ProducerFactory bean
     */
    @Bean
    public ProducerFactory<String, Event> producerFactory() {
        DefaultKafkaProducerFactory<String, Event> factory = new DefaultKafkaProducerFactory<>(producerConfiguration());

        // Set to true to create a producer per thread instead of singleton that is shared by all clients.
        // Clients must call closeThreadBoundProducer() to physically close the producer when it is no longer
        // needed. These producers will not be closed by destroy() or reset().
        factory.setProducerPerThread(false);

        // It is relevant if setProducerPerThread(true) is used.
        factory.addListener(new ProducerFactory.Listener<>() {
            @Override
            public void producerAdded(@NonNull String id, @NonNull Producer<String, Event> producer) {
                log.info("ProducerFactory > listener: message producer has been added, id: {}", id);
            }

            @Override
            public void producerRemoved(@NonNull String id, @NonNull Producer<String, Event> producer) {
                log.info("ProducerFactory > listener: message producer has been removed, id: {}", id);
            }
        });

        factory.addPostProcessor(new ProducerPostProcessor<>() {
            @Override
            public Producer<String, Event> apply(Producer<String, Event> eventProducer) {
                log.info("ProducerFactory > PostProcessor > apply");
                return eventProducer;
            }

            @Override
            @Nonnull
            public <V> Function<V, Producer<String, Event>> compose(@NonNull Function<? super V, ? extends Producer<String, Event>> before) {
                log.info("ProducerFactory > PostProcessor > compose");
                return ProducerPostProcessor.super.compose(before);
            }

            @Override
            @Nonnull
            public <V> Function<Producer<String, Event>, V> andThen(@NonNull Function<? super Producer<String, Event>, ? extends V> after) {
                log.info("ProducerFactory > PostProcessor > andThen");
                return ProducerPostProcessor.super.andThen(after);
            }
        });

        return factory;
    }

    @Bean
    public KafkaTemplate<String, Event> kafkaTemplate() {
        var factory = producerFactory();
        log.debug("initializing a KafkaTemplate using the following setting: {{}}", factoryConfigurationToString(factory));
        return new KafkaTemplate<>(factory);
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

    private Map<String, Object> producerConfiguration() {
        Map<String, Object> configs = new HashMap<>();
        configs.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, kafkaBootstrapServers);
        configs.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
        configs.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, JsonSerializer.class);

        // default:	true
        //
        // When set to ‘true’, the producer will ensure that exactly one copy of each message is written in the
        // stream. If ‘false’, producer retries due to broker failures, etc., may write duplicates of the
        // retried message in the stream. Note that enabling idempotence requires
        // max.in.flight.requests.per.connection to be less than or equal to 5 (with message ordering preserved
        // for any allowable value), retries to be greater than 0, and acks must be ‘all’.
        //
        // Idempotence is enabled by default if no conflicting configurations are set. If conflicting
        // configurations are set and idempotence is not explicitly enabled, idempotence is disabled. If
        // idempotence is explicitly enabled and conflicting configurations are set, a ConfigException is
        // thrown.
        configs.put(ProducerConfig.ENABLE_IDEMPOTENCE_CONFIG, kafkaProducerEnableIdempotence);


        // default:	all
        // valid values: [all, -1, 0, 1]
        //
        // The number of acknowledgments the producer requires the leader to have received before considering a
        // request complete. This controls the durability of records that are sent. The following settings are allowed:
        //
        // 0:   If set to zero then the producer will not wait for any acknowledgment from the server at all. The
        //      record will be immediately added to the socket buffer and considered sent. No guarantee can be made
        //      that the server has received the record in this case, and the retries configuration will not take
        //      effect (as the client won’t generally know of any failures). The offset given back for each record
        //      will always be set to -1.
        //
        // 1:   This will mean the leader will write the record to its local log but will respond without awaiting
        //      full acknowledgment from all followers. In this case should the leader fail immediately after
        //      acknowledging the record but before the followers have replicated it then the record will be lost.
        //
        // all: This means the leader will wait for the full set of in-sync replicas to acknowledge the record. This
        //      guarantees that the record will not be lost as long as at least one in-sync replica remains alive.
        //      This is the strongest available guarantee. This is equivalent to the acks=-1 setting.
        //
        // Note that enabling idempotence requires this config value to be ‘all’. If conflicting configurations are
        // set and idempotence is not explicitly enabled, idempotence is disabled.

        // Idempotent producer ensures that duplicates are not introduced due to unexpected producer retries.
        configs.put(ProducerConfig.ACKS_CONFIG, kafkaProducerAcks);

        // default: Integer.MAX_VALUE (2147483647)
        //
        // Producer attempts to send a message for this configured number of retries before marking it as failed.
        configs.put(ProducerConfig.RETRIES_CONFIG, kafkaProducerRetries);

        // default: 0
        //
        // How long to wait until we send a batch to kafka. This can introduce small delay in message processing
        // but decrease network calls between kafka producer and kafka cluster (as we are sending messages in
        // batches) which increase throughput and producer efficiency.
        configs.put(ProducerConfig.LINGER_MS_CONFIG, kafkaProducerLingerMs);

        // default: 120000 (2 min)
        //
        // Producer doesn’t retry the record forever if retries= Integer.MAX_VALUE, it is bounded by timeout.
        // Record will be failed if it cannot be delivered within this configured time.
        configs.put(ProducerConfig.DELIVERY_TIMEOUT_MS_CONFIG, kafkaProducerDeliveryTimeoutMs);

        // default:	30000 (30 seconds)
        //
        // Controls the maximum amount of time the client will wait for the response of a request. If the
        // response is not received before the timeout elapses the client will resend the request if necessary
        // or fail the request if retries are exhausted. This should be larger than replica.lag.time.max.ms
        // (a broker configuration, default: 30000 (30 seconds) to reduce the possibility of message duplication
        // due to unnecessary producer retries.
        configs.put(ProducerConfig.REQUEST_TIMEOUT_MS_CONFIG, kafkaProducerRequestTimeoutMs);

        // default: 100 (0.1 second)
        //
        // The amount of time to wait before attempting to retry a failed request to a given topic partition.
        // This avoids repeatedly sending requests in a tight loop under some failure scenarios. This value is
        // the initial backoff value and will increase exponentially for each failed request, up to the
        // retry.backoff.max.ms value.
        configs.put(ProducerConfig.RETRY_BACKOFF_MS_CONFIG, kafkaProducerRetryBackoffMs);

        // default:	1000 (1 second)
        //
        // The maximum amount of time in milliseconds to wait when retrying a request to the broker that has
        // repeatedly failed. If provided, the backoff per client will increase exponentially for each failed
        // request, up to this maximum. To prevent all clients from being synchronized upon retry,
        // a randomized jitter with a factor of 0.2 will be applied to the backoff, resulting in the backoff
        // falling within a range between 20% below and 20% above the computed value. If retry.backoff.ms is set
        // to be higher than retry.backoff.max.ms, then retry.backoff.max.ms will be used as a constant backoff
        // from the beginning without any exponential increase.
        configs.put(ProducerConfig.RETRY_BACKOFF_MAX_MS_CONFIG, kafkaProducerRetryBackoffMaxMs);
        return configs;
    }

    /**
     * Used for logging purposes only.
     *
     * @param producerFactory the factory used bz the message producer
     * @return factory configuration in human-readable format
     */
    private String factoryConfigurationToString(ProducerFactory<String, Event> producerFactory) {
         var sb = new StringBuilder();
        producerFactory.
                getConfigurationProperties().
                forEach((key, value) -> sb.append(String.format("\"%s\": \"%s\", ", key, value)));

        sb.setLength(sb.length() - 2);
        return sb.toString();
    }
}
