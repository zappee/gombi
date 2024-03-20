/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since: February 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Service discovery.
 */
package com.remal.gombi.template.rest.service;

import com.remal.gombi.template.commons.model.User;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.net.URI;

@Service
public class UserService {
    private final ServiceDiscovery serviceDiscovery;
    private final RestTemplate restTemplate;

    /**
     * Constructor with object injections.
     *
     * @param serviceDiscovery object to be injected by spring
     */
    public UserService(ServiceDiscovery serviceDiscovery, RestTemplate restTemplate) {
        this.serviceDiscovery = serviceDiscovery;
        this.restTemplate = restTemplate;
    }

    public User getUser(String userId) {
        URI uri = getServiceUri().resolve("/api/user/" + userId);
        return restTemplate.getForObject(uri, User.class);
    }

    private URI getServiceUri() {
        return serviceDiscovery.getServiceUri("user-service");
    }
}
