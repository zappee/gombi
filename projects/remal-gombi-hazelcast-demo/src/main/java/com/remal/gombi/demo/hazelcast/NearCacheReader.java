package com.remal.gombi.demo.hazelcast;

import com.hazelcast.core.HazelcastInstance;
import com.hazelcast.map.IMap;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Objects;
import java.util.Timer;
import java.util.TimerTask;

public class NearCacheReader {

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("mm:ss");

    public static void main(String[] args) {
        HazelcastInstance hazelcastClient = HazelcastConfiguration.getHazelcastInstance();
        IMap<String, Integer> nearCache = hazelcastClient.getMap(HazelcastConfiguration.MAP_ID);

        TimerTask task = new TimerTask() {
            @Override
            public void run() {
                Integer value = nearCache.get(HazelcastConfiguration.KEY);
                if (Objects.isNull(value)) {
                    System.out.println(FORMATTER.format(LocalTime.now()) +": NearCache miss");
                } else {
                    System.out.println(FORMATTER.format(LocalTime.now()) +": NearCache hit: " + value);
                }
            }
        };

        // Schedule the timer task to run after 1 second
        Timer timer = new Timer();
        timer.scheduleAtFixedRate(task, 0,1000);
    }
}
