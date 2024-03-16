/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since: February 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Spring REST endpoint.
 */

package com.remal.gombi.template.rest.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.naming.ServiceUnavailableException;
import java.net.URI;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.ThreadLocalRandom;
import java.util.stream.Collectors;

@Slf4j
@RestController
@RequestMapping("/api/hello")
public class HelloController {

    @Autowired
    private DiscoveryClient discoveryClient;

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyy-MM-dd HH:mm:ss");
    @GetMapping("")
    public String sayHello() throws ServiceUnavailableException {
        URI serviceUri = getServiceUrl("user-service")
                .map(s -> s.resolve("/api/user"))
                .orElseThrow(ServiceUnavailableException::new);

        //@Autowired
        //RestTemplate restTemplate;

        //RestTemplate restTemplate = new RestTemplate();
        //String userName = restTemplate.getForEntity(service, String.class).getBody();

        String response = String.format("Hello <b>%s</b>, the time is <b>%s</b>.",
                serviceUri,
                LocalDateTime.now().format(DATE_TIME_FORMATTER));

        log.debug("calling sayHello(): {response: \"{}}\"}", response);
        return response;
    }

    private Optional<URI> getServiceUrl(String serviceId) {
        List<ServiceInstance> serviceInstances = discoveryClient.getInstances("user-service");
        log.debug(
                "service instances: {}",
                serviceInstances.stream().map(x -> x.getUri().toString()).collect(Collectors.joining(", ")));

        /*Optional<URI> uri = serviceInstances
                .stream()
                .findFirst()
                .map(ServiceInstance::getUri);*/

        int randomIndex = ThreadLocalRandom.current().nextInt(serviceInstances.size());
        Optional<URI> uri = Optional.of(serviceInstances.get(randomIndex).getUri());

        log.debug("rest endpoint url: {serviceId: {}, uri: {}}", serviceId, uri);
        return uri;
    }
}
