/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since: February 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Service discovery.
 */
package com.remal.gombi.template.service.hello.configuration;

import com.remal.gombi.template.commons.spring.discovery.ConsulServiceDiscovery;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ServiceDiscoveryConfiguration {

    @Bean
    public ConsulServiceDiscovery initialize(DiscoveryClient discoveryClient) {
        return new ConsulServiceDiscovery(discoveryClient);
    }
}
