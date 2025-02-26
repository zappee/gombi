/*
 *  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  February 2025
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     A simple Kafka message sender.
 */
package com.remal.gombi.kafka.player.kafka;

import com.remal.gombi.kafka.player.commons.NullPrintStream;
import com.remal.gombi.kafka.player.picocli.param.KafkaConnectionGroup;
import lombok.Getter;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;

import java.io.PrintStream;
import java.util.Objects;
import java.util.Properties;

public class KafkaSender {

    private final PrintStream logWriter;

    @Getter
    private final String bootstrapServers;

    @Getter
    private final String topic;

    private KafkaProducer<String, String> producer;

    public KafkaSender(boolean quiet, KafkaConnectionGroup params) {
        this.logWriter = quiet ? NullPrintStream.getPrintStream() : System.out;
        this.topic = params.getKafkaTopic();

        var kafkaPort = params.getKafkaPort();
        this.bootstrapServers = params.getKafkaHost() + (Objects.nonNull(kafkaPort) ? ":" + kafkaPort : "");
    }

    public void connect() {
        Properties props = new Properties();
        props.put("bootstrap.servers", bootstrapServers);
        props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
        props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");

        producer = new KafkaProducer<>(props);
    }

    public void send(String key, String message) {
        ProducerRecord<String, String> record = new ProducerRecord<>(topic, key, message);
        producer.send(record, (metadata, exception) -> {
            if (exception != null) {
                logWriter.printf(
                        "An unexpected error has been occurred while sending a message to Kafka. %s",
                        exception.getMessage());
            }
        });
    }

    public void disconnect() {
        if (Objects.nonNull(producer)) {
            producer.close();
        }
    }
}
