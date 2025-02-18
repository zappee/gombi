/*
 *  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  February 2025
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Hazelcast Java demo: Hazelcast configuration.
 */
package com.remal.gombi.demo.hazelcast.commons;

import com.hazelcast.client.HazelcastClient;
import com.hazelcast.client.config.ClientConfig;
import com.hazelcast.config.EvictionConfig;
import com.hazelcast.config.EvictionPolicy;
import com.hazelcast.config.InMemoryFormat;
import com.hazelcast.config.NearCacheConfig;
import com.hazelcast.core.HazelcastInstance;

public class HazelcastConfiguration {

    public static final String COUNTER_MAP = "counter-map";

    private static final String HZ_CLUSTER_NAME = "gombi-dev";
    private static final String HZ_CLUSTER_ADDRESS_1 = "localhost:13063";
    private static final String HZ_CLUSTER_ADDRESS_2 = "localhost:13073";

    public static HazelcastInstance getHazelcastInstance() {
        NearCacheConfig nearCacheConfigForCounterMap = new NearCacheConfig(COUNTER_MAP)
                .setInMemoryFormat(InMemoryFormat.BINARY) // or InMemoryFormat.OBJECT
                .setEvictionConfig(new EvictionConfig()
                        .setEvictionPolicy(EvictionPolicy.LRU)
                        .setSize(1000))
                .setTimeToLiveSeconds(30)
                .setMaxIdleSeconds(10);

        ClientConfig clientConfig = new ClientConfig();
        clientConfig.setClusterName(HZ_CLUSTER_NAME);
        clientConfig.getNetworkConfig().getAddresses().add(HZ_CLUSTER_ADDRESS_1);
        clientConfig.getNetworkConfig().getAddresses().add(HZ_CLUSTER_ADDRESS_2);
        clientConfig.addNearCacheConfig(nearCacheConfigForCounterMap);

        return HazelcastClient.newHazelcastClient(clientConfig);
    }
}
