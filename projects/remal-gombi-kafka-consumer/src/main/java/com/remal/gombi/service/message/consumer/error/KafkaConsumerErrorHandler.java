/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  October 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Kafka error handler.
 */
package com.remal.gombi.service.message.consumer.error;

import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.consumer.Consumer;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.common.errors.RecordDeserializationException;
import org.springframework.kafka.listener.CommonErrorHandler;
import org.springframework.kafka.listener.MessageListenerContainer;

@Slf4j
public class KafkaConsumerErrorHandler implements CommonErrorHandler {

    @Override
    public boolean handleOne(Exception exception,
                             ConsumerRecord<?, ?> record,
                             Consumer<?, ?> consumer,
                             MessageListenerContainer container) {
        return handle(exception, consumer);
    }

    @Override
    public void handleOtherException(Exception exception,
                                     Consumer<?, ?> consumer,
                                     MessageListenerContainer container,
                                     boolean batchListener) {
        handle(exception, consumer);
    }

    private boolean handle(Exception exception, Consumer<?,?> consumer) {
        if (exception instanceof RecordDeserializationException e) {
            log.error("Unable to parse the incoming record. {}", e.getMessage());
            consumer.seek(e.topicPartition(), e.offset() + 1L);
            consumer.commitSync();
        } else {
            log.error("An unexpected error occurred while trying to handle the incoming message: ", exception);
        }
        return false;
    }
}
