/*
 *  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  January 2025
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Class to manage the database operations.
 */
package com.remal.gombi.service.message.consumer.repository;

import com.remal.gombi.service.message.consumer.entity.EventEntity;
import org.springframework.data.repository.ListCrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EventRepository extends ListCrudRepository<EventEntity, Long> {
}
