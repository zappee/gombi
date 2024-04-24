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
import com.remal.gombi.template.commons.spring.monitoring.MicrometerBuilder;
import com.remal.gombi.template.service.hello.monitoring.LogCall;
import com.remal.gombi.template.service.hello.service.ConfigurationService;
import com.remal.gombi.template.service.hello.service.UserService;
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
@RequestMapping("/api")
public class HelloController {

    private final ConfigurationService configuration;
    private final UserService userService;

    /**
     * Constructor with object injections.
     *
     * @param userService object to be injected by spring
     */
    public HelloController(UserService userService,
                           ConfigurationService configuration) {
        this.userService = userService;
        this.configuration = configuration;
    }

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyy-MM-dd HH:mm:ss");

    @GetMapping("hello")
    @LogCall
    public String hello() {
        AtomicReference<String> result = new AtomicReference<>();
        MicrometerBuilder.getRestResponseTimeTimer("hello").record(() -> {
            String username = configuration.getUsername();
            User user = userService.getUser(username);
            String description = (Math.random() < 0.5) ? configuration.getDescription() : null;
            user.setDescription(description);

            String now = LocalDateTime.now().format(DATE_TIME_FORMATTER);
            String message = String.format("Hello %s, the time is %s.", user.getUsername(), now);
            message += Objects.nonNull((user.getDescription())) ? "<br>" + user.getDescription() : "";
            result.set(message);
        });
        return result.get();
    }

    @GetMapping("joke")
    @LogCall
    public String joke() {
        AtomicReference<String> result = new AtomicReference<>();
        MicrometerBuilder.getRestResponseTimeTimer("joke").record(() ->
                result.set("When Alexander Graham Bell invented the telephone, "
                        + "he had three missed calls from Chuck Norris")
        );
        return result.get();
    }
}
