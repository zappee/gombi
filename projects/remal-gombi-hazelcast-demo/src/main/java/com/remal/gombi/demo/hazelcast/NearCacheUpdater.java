package com.remal.gombi.demo.hazelcast;

import com.hazelcast.core.HazelcastInstance;
import com.hazelcast.map.IMap;

import java.util.Timer;
import java.util.TimerTask;

public class NearCacheUpdater {
    public static void main(String[] args) {
        HazelcastInstance hazelcastClient = HazelcastConfiguration.getHazelcastInstance();
        IMap<String, Integer> nearCache = hazelcastClient.getMap(HazelcastConfiguration.MAP_ID);

        nearCache.put(HazelcastConfiguration.KEY, 1);

        TimerTask task = new TimerTask() {
            @Override
            public void run() {
                int value = nearCache.get(HazelcastConfiguration.KEY);
                value++;
                nearCache.put(HazelcastConfiguration.KEY, value);
                System.out.println("Value has been updated to  " + value);
            }
        };

        // Schedule the timer task to run after 1 second
        Timer timer = new Timer();
        timer.scheduleAtFixedRate(task, 0,1000);
    }
}
