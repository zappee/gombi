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
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EventRepository extends JpaRepository<EventEntity, Long> {

    @Query("SELECT COUNT(e.id) FROM EventEntity e")
    Long countById();

    @Query("SELECT e FROM EventEntity e ORDER BY e.id DESC LIMIT 20")
    List<EventEntity> findLast20();
}
