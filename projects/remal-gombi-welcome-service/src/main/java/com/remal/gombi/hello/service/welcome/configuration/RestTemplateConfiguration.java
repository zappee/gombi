/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  February 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Spring bean configuration.
 */
package com.remal.gombi.hello.service.welcome.configuration;


import org.springframework.boot.ssl.SslBundles;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

@Configuration
public class RestTemplateConfiguration {

    private static final String SSL_BUNDLE_ID = "rest-template";

    /**
     * Rest template configuration for HTTPS.
     *
     * @return restTemplate instance
     */
    @Bean
    public RestTemplate restTemplate(RestTemplateBuilder builder, SslBundles sslBundles) {
        return builder.sslBundle(sslBundles.getBundle(SSL_BUNDLE_ID)).build();
    }
}
