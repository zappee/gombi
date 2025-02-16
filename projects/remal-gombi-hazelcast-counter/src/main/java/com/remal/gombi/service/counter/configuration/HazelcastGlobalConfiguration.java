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

import com.hazelcast.client.HazelcastClient;
import com.hazelcast.client.config.ClientConfig;
import com.hazelcast.config.EvictionConfig;
import com.hazelcast.config.EvictionPolicy;
import com.hazelcast.config.InMemoryFormat;
import com.hazelcast.config.NearCacheConfig;
import com.hazelcast.core.HazelcastInstance;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class HazelcastGlobalConfiguration {

    public static final String COUNTER = "COUNTER";

    @Bean
    public HazelcastInstance hazelcastClient() {
        return HazelcastClient.newHazelcastClient(clientConfig());
    }

    private ClientConfig clientConfig() {
        ClientConfig clientConfig = new ClientConfig();
        clientConfig.setClusterName("gombi-dev");
        clientConfig.getNetworkConfig().getAddresses().add("hazelcast-1.hello.com");
        clientConfig.addNearCacheConfig(shortLivedNearCacheConfig(COUNTER));
        return clientConfig;
    }

    /**
     * Creates a new Hazelcast Near-Cache configuration.
     *
     * @param name the name of the Near Cache
     * @return the cache configuration instance
     */
    private NearCacheConfig shortLivedNearCacheConfig(String name) {
        return new NearCacheConfig(name)
                .setInMemoryFormat(InMemoryFormat.BINARY)


                // Limits the size of a map. If the size of the map grows larger than the limit, the eviction
                // policy defines which entries to remove from the map to reduce its size. You can configure
                // the size limit and eviction policy using the elements size and eviction-policy.
                .setEvictionConfig(new EvictionConfig()
                        .setEvictionPolicy(EvictionPolicy.LRU)
                        .setSize(1000))

                // This is relative to the time of a map’s last write.
                // For example a time to live (TTL) of 60 seconds means that an entry will be removed
                // if it is not written to at least every 60 seconds.
                //
                // Default value: 0 (disabled)
                .setTimeToLiveSeconds(30)

                // This is relative to the time of the last get(), put(), EntryProcessor.process() or containsKey()
                // method called on it. For example a setting of 60 seconds means that an entry will be removed
                // if it is not written to or read from at least every 60 seconds.
                //
                // Default value: 0 (disabled)
                .setMaxIdleSeconds(15);

    }
}
