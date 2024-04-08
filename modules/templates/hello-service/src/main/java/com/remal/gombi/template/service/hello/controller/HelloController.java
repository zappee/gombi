/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  February 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Spring REST endpoint.
 */
package com.remal.gombi.template.service.hello.controller;

import com.remal.gombi.template.commons.model.User;
import com.remal.gombi.template.commons.monitoring.MicrometerBuilder;
import com.remal.gombi.template.service.hello.monitoring.LogCall;
import com.remal.gombi.template.service.hello.service.ConfigurationService;
import com.remal.gombi.template.service.hello.service.UserService;
import io.micrometer.core.instrument.Timer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Objects;
import java.util.concurrent.atomic.AtomicReference;

@Slf4j
@RestController
@RequestMapping("/api/hello")
public class HelloController {

    private final ConfigurationService configuration;
    private final UserService userService;
    private final Timer sayHelloTimer;

    /**
     * Constructor with object injections.
     *
     * @param userService object to be injected by spring
     */
    public HelloController(UserService userService,
                           ConfigurationService configuration,
                           MicrometerBuilder micrometer) {
        this.userService = userService;
        this.configuration = configuration;
        sayHelloTimer = micrometer.buildTimer("say_hello");
    }

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyy-MM-dd HH:mm:ss");

    @GetMapping("")
    @LogCall
    public String sayHello() {
        AtomicReference<String> result = new AtomicReference<>();

        sayHelloTimer.record(() -> {
            String username = configuration.getUsername();
            User user = userService.getUser(username);

            boolean random = Math.random() < 0.5;
            if (random) {
                user.setDescription(configuration.getDescription());
            }

            String now = LocalDateTime.now().format(DATE_TIME_FORMATTER);
            String message = String.format("Hello %s, the time is %s.", user.getUsername(), now);
            message += Objects.nonNull((user.getDescription())) ? "<br>" + user.getDescription() : "";
            result.set(message);
        });

        return result.get();
    }
}
