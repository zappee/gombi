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

    /**
     * Hazelcast client configuration.
     *
     * <PRE>
     * Near-Cache-ID refers to the configuration of the Near-Cache that
     * exists on the client side. The Near-Cache-ID is used to configure
     * a Near Cache that is associated with a specific distributed map.
     * It is the key you use to identify the Near Cache configuration on
     * the client side.
     *
     * Map-ID refers to the distributed map that exists in the Hazelcast
     * cluster. The Map-ID is used to identify a distributed map within the
     * Hazelcast cluster. It is the key you use to access the distributed
     * data structure.
     * </PRE>
     *
     * @return Hazelcast client instance
     */
    public static HazelcastInstance getHazelcastInstance() {
        NearCacheConfig nearCacheConfigForCounterMap = new NearCacheConfig(COUNTER_MAP)
                .setInMemoryFormat(InMemoryFormat.BINARY)
                .setTimeToLiveSeconds(30)
                .setMaxIdleSeconds(10)
                .setEvictionConfig(new EvictionConfig()
                        .setEvictionPolicy(EvictionPolicy.LRU)
                        .setSize(1000));

        ClientConfig clientConfig = new ClientConfig();
        clientConfig.setClusterName(HZ_CLUSTER_NAME);
        clientConfig.getNetworkConfig().getAddresses().add(HZ_CLUSTER_ADDRESS_1);
        clientConfig.getNetworkConfig().getAddresses().add(HZ_CLUSTER_ADDRESS_2);
        clientConfig.addNearCacheConfig(nearCacheConfigForCounterMap);

        return HazelcastClient.newHazelcastClient(clientConfig);
    }
}
