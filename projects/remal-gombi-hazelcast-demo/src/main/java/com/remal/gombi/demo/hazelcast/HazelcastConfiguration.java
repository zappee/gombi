package com.remal.gombi.demo.hazelcast;

import com.hazelcast.client.HazelcastClient;
import com.hazelcast.client.config.ClientConfig;
import com.hazelcast.config.EvictionConfig;
import com.hazelcast.config.EvictionPolicy;
import com.hazelcast.config.InMemoryFormat;
import com.hazelcast.config.NearCacheConfig;
import com.hazelcast.core.HazelcastInstance;

public class HazelcastConfiguration {

    public static final String MAP_ID = "counter-1";
    public static final String KEY = "key";

    public static HazelcastInstance getHazelcastInstance() {
        NearCacheConfig nearCacheConfig = new NearCacheConfig("mostlyReadMap")
                .setInMemoryFormat(InMemoryFormat.BINARY) // or InMemoryFormat.OBJECT
                .setEvictionConfig(new EvictionConfig()
                        .setEvictionPolicy(EvictionPolicy.LRU)
                        .setSize(1000))
                .setTimeToLiveSeconds(30)
                .setMaxIdleSeconds(10);


        ClientConfig clientConfig = new ClientConfig();
        clientConfig.setClusterName("gombi-dev");
        clientConfig.getNetworkConfig().getAddresses().add("localhost:13063");
        clientConfig.getNetworkConfig().getAddresses().add("localhost:13073");
        clientConfig.addNearCacheConfig(nearCacheConfig);

        return HazelcastClient.newHazelcastClient(clientConfig);
    }
}
