/*
 *  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  January 2025
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Mapper between POJO and DTO and vica versa.
 */
package com.remal.gombi.service.message.consumer.mapper;

import com.remal.gombi.commons.model.Event;
import com.remal.gombi.service.message.consumer.entity.EventEntity;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper
public interface EventMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "topic", ignore = true)
    @Mapping(target = "partition", ignore = true)
    @Mapping(target = "groupId", ignore = true)
    @Mapping(target = "payload", ignore = true)
    EventEntity toEntity(Event pojo);
}
