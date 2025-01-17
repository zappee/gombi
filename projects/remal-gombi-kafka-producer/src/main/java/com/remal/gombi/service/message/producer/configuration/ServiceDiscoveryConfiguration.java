/*
 *  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  January 2025
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Service discovery.
 */
package com.remal.gombi.service.message.producer.configuration;

import com.remal.gombi.commons.spring.discovery.ConsulServiceDiscovery;
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
