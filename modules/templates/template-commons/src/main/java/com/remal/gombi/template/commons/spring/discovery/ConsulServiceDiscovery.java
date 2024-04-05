/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  February 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Service discovery.
 */
package com.remal.gombi.template.commons.spring.discovery;

import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.discovery.DiscoveryClient;

import java.net.URI;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;
import java.util.stream.Collectors;

@Slf4j
public class ConsulServiceDiscovery {

    private final DiscoveryClient discoveryClient;

    /**
     * Constructor with object injections.
     *
     * @param discoveryClient object to be injected by spring
     */
    public ConsulServiceDiscovery(DiscoveryClient discoveryClient) {
        this.discoveryClient = discoveryClient;
    }

    public URI getServiceUri(String serviceId) {
        log.debug("getting service URIs for {}...", serviceId);

        List<ServiceInstance> serviceInstances = discoveryClient.getInstances(serviceId);
        log.debug("service URIs for {}: {}",
                serviceId,
                serviceInstances.stream().map(x -> x.getUri().toString()).collect(Collectors.joining(", ")));

        int randomIndex = ThreadLocalRandom.current().nextInt(serviceInstances.size());
        URI uri = serviceInstances.get(randomIndex).getUri();
        log.info("selected URI for {} is {}", serviceId, uri);
        return uri;
    }
}
