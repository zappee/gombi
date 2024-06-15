/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  April 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Micrometer ID generator. The IDs are used by Micrometer and Prometheus to
 *     help collecting and filter metrics.
 */
package com.remal.gombi.hello.service.user.micrometer;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.Timer;
import io.micrometer.core.instrument.composite.CompositeMeterRegistry;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class MicrometerBuilder {

    private final CompositeMeterRegistry meterRegistry;

    public MicrometerBuilder(CompositeMeterRegistry meterRegistry) {
        this.meterRegistry = meterRegistry;
    }

    /**
     * Used to monitor the execution time of  any method, like a rest endpoint.
     *
     * @param id the name of the method to be timed
     * @return the registered micrometer timer
     */
    public Timer getTimer(String id) {
        return Timer.builder("execution_time").tag("id", id).register(meterRegistry);
    }

    /**
     * Used to monitor the response http code of a rest endpoint.
     *
     * @param id the name of the method to be monitored
     * @return the registered micrometer timer
     */
    public Counter getCounter(String id) {
        return Counter.builder("http_status_code").tags("id", id).register(meterRegistry);
    }

    /**
     * Used to monitor the response http code of a rest endpoint.
     *
     * @param id the name of the method to be monitored
     * @param httpStatusCode the http response status code
     * @return the registered micrometer timer
     */
    public Counter getCounter(String id, String httpStatusCode) {
        return Counter.builder("http_status_code").tags("id", id, "status_code", httpStatusCode).register(meterRegistry);
    }
}
