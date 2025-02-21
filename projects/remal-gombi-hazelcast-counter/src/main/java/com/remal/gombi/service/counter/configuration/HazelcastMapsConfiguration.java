/*
 *  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  February 2025
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Hazelcast cache configuration.
 */
package com.remal.gombi.service.counter.configuration;

import com.hazelcast.core.HazelcastInstance;
import com.hazelcast.map.IMap;
import com.remal.gombi.service.counter.haselcast.HazelcastCounterMapListener;
import lombok.AllArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.Map;

@Configuration
@AllArgsConstructor
public class HazelcastMapsConfiguration {

    private final HazelcastInstance hazelcastClient;
    
    @Bean
    public Map<String, Integer> counterMap() {
        IMap<String, Integer> counters = hazelcastClient.getMap(HazelcastGlobalConfiguration.COUNTER_MAP_ID);
        counters.addEntryListener(new HazelcastCounterMapListener(), true);
        return counters;
    }
}
