/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  February 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Spring bean configuration.
 */
package com.remal.gombi.template.service.hello.configuration;

import com.remal.gombi.template.service.hello.exception.InitializationException;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.client5.http.impl.io.PoolingHttpClientConnectionManagerBuilder;
import org.apache.hc.client5.http.io.HttpClientConnectionManager;
import org.apache.hc.client5.http.ssl.SSLConnectionSocketFactory;
import org.apache.hc.core5.ssl.SSLContextBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;

import javax.net.ssl.SSLContext;
import java.io.File;
import java.io.IOException;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateException;

@Configuration
public class RestTemplateConfiguration {

    private final ResourceLoader resourceLoader;

    @Value("${server.ssl.key-store}")
    private String trustStore;

    @Value("${server.ssl.key-store-password}")
    private String trustStorePassword;

    public RestTemplateConfiguration(ResourceLoader resourceLoader) {
        this.resourceLoader = resourceLoader;
    }

    /**
     * Rest template configuration for HTTPS.
     *
     * @return restTemplate instance
     */
    @Bean
    public RestTemplate restTemplate() {
        try {
            File trustStoreFileResource = resourceLoader.getResource(trustStore).getFile();
            SSLContext sslContext = new SSLContextBuilder()
                    .loadTrustMaterial(trustStoreFileResource, trustStorePassword.toCharArray())
                    .build();
            SSLConnectionSocketFactory connectionFactory = new SSLConnectionSocketFactory(sslContext);
            HttpClientConnectionManager connectionManager = PoolingHttpClientConnectionManagerBuilder.create()
                    .setSSLSocketFactory(connectionFactory)
                    .build();
            CloseableHttpClient httpClient = HttpClients.custom().setConnectionManager(connectionManager).build();
            ClientHttpRequestFactory requestFactory = new HttpComponentsClientHttpRequestFactory(httpClient);
            return new RestTemplate(requestFactory);

        } catch (IOException
                 | NoSuchAlgorithmException
                 | KeyStoreException
                 | CertificateException
                 | KeyManagementException e) {
            throw new InitializationException("Error while initializing the RestTemplate.", e);
        }
    }
}
