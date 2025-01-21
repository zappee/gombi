/*
 *  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  January 2025
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *    JPA entity.
 */
package com.remal.gombi.service.message.consumer.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "event")
@Data
public class EventEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "event-id-sequence")
    @SequenceGenerator(name = "event-id-sequence", sequenceName = "event_id_seq", allocationSize = 1)
    @Column(name = "id")
    private Long id;

     @Column(name = "source", length = 30)
    private String source;

    @Column(name = "owner", length = 50)
    private String owner;

    @Column(name = "payload")
    private String payload;
}
