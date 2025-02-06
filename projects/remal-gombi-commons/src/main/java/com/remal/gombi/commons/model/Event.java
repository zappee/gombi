/*
 *  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  May 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Simple POJO, used with kafka.
 */
package com.remal.gombi.commons.model;

import com.remal.gombi.commons.converter.LocalDateTimeConverter;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.Objects;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Event {

    /**
     * The source system identifier that produced the message.
     */
    private String sourceSystem;

    /**
     * Identifier that identify the user who initialized the event.
     */
    private String userId;

    /**
     * The business content.
     */
    private String payload;

    /**
     * The creation time of the event in UTC zone.
     */
    @Builder.Default
    private LocalDateTime createdInUtc = LocalDateTime.now(ZoneOffset.UTC);

    /**
     * Returns a string representation of the object.
     *
     * @return representation of the object
     */
    public String toString() {
        return "{userId: " + (Objects.isNull(userId) ? "null" : "\"" + userId) + "\", "
                + "sourceSystem: " + (Objects.isNull(sourceSystem) ? "null" : "\"" + sourceSystem) + "\", "
                + "payload: " + (Objects.isNull(payload) ? "null" : "\"" + payload) + "\", "
                + "createdInUtc: " + LocalDateTimeConverter.toString(createdInUtc);
    }
}
