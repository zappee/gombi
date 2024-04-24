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
package com.remal.gombi.template.commons.spring.monitoring;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.Metrics;
import io.micrometer.core.instrument.Timer;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class MicrometerBuilder {

    public static final String CLOUD_CONFIG_ACCESS_LOG_TEMPLATE = "value from the kv store: {{}: \"{}\"}";

    /**
     * Used to monitor the access to the key/value pairs from the distributed
     * configuration environment, e.g. Hashicorp Consul.
     *
     * @param key key that represents the value that is read from the KV store
     * @return the registered micrometer counter
     */
    public static Counter getCloudConfigAccessMeter(String key) {
        return Metrics.counter("cloud.config.access.counter", "key", key);
    }

    /**
     * Used to monitor the access to any rest endpoint.
     *
     * @param endpointId the rest endpoint identifier
     * @return the registered micrometer timer
     */
    public static Timer getRestResponseTimeTimer(String endpointId) {
        return Metrics.timer("rest.request.duration", "endpoint", endpointId);
    }
}
