/*
 *  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  February 2025
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Hazelcast Java demo: Near cache writer Java application.
 */
package com.remal.gombi.demo.hazelcast;

import com.hazelcast.core.HazelcastInstance;
import com.hazelcast.map.IMap;
import com.remal.gombi.demo.hazelcast.commons.HazelcastConfiguration;
import com.remal.gombi.demo.hazelcast.commons.LocalTimeConverter;
import com.remal.gombi.demo.hazelcast.commons.MapKeyGenerator;

import java.util.Timer;
import java.util.TimerTask;

public class NearCacheUpdater {

    public static void main(String[] args) {
        HazelcastInstance hazelcastClient = HazelcastConfiguration.getHazelcastInstance();
        String username = "zappee";

        IMap<String, Integer> nearCache = hazelcastClient.getMap(HazelcastConfiguration.COUNTER_MAP);
        nearCache.put(MapKeyGenerator.getKey(username), 1);

        TimerTask task = new TimerTask() {
            @Override
            public void run() {
                int value = nearCache.get(MapKeyGenerator.getKey(username));
                value++;
                nearCache.put(MapKeyGenerator.getKey(username), value);

                System.out.printf(
                        "[%s] value in the cache has been updated: {username: \"%s\", new-value: %s}\n",
                        LocalTimeConverter.nowAsString(),
                        username,
                        value);
            }
        };

        // Schedule the timer task to run after 1 second
        Timer timer = new Timer();
        timer.scheduleAtFixedRate(task, 0,1000);
    }
}
