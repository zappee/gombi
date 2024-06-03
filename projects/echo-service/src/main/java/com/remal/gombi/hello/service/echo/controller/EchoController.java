/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  February 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Spring REST endpoint.
 */
package com.remal.gombi.hello.service.echo.controller;

import com.remal.gombi.hello.service.echo.monitoring.LogExecutionTime;
import com.remal.gombi.hello.service.echo.service.ConfigurationService;
import com.remal.gombi.hello.service.echo.service.UserService;
import com.remal.gombi.hello.commons.model.User;
import com.remal.gombi.hello.commons.spring.monitoring.MicrometerBuilder;
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
public class EchoController {

    private final ConfigurationService configuration;
    private final UserService userService;

    /**
     * Constructor with object injections.
     *
     * @param userService object to be injected by spring
     */
    public EchoController(UserService userService,
                          ConfigurationService configuration) {
        this.userService = userService;
        this.configuration = configuration;
    }

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyy-MM-dd HH:mm:ss");

    @GetMapping("echo")
    @LogExecutionTime
    public String echo() {
        AtomicReference<String> result = new AtomicReference<>();
        MicrometerBuilder.getRestResponseTimeTimer("echo").record(() -> {
            String userId = "1";
            User user = userService.getUser(userId);
            String description = (Math.random() < 0.5) ? configuration.getOptionA() : configuration.getOptionB();
            user.setDescription(description);

            String now = LocalDateTime.now().format(DATE_TIME_FORMATTER);
            String message = String.format("Hello %s, the time is %s.", user.getEmail(), now);
            message += Objects.nonNull((user.getDescription())) ? "<br>" + user.getDescription() : "";
            result.set(message);
        });
        return result.get();
    }

    @GetMapping("joke")
    @LogExecutionTime
    public String joke() {
        AtomicReference<String> result = new AtomicReference<>();
        MicrometerBuilder.getRestResponseTimeTimer("joke").record(() ->
                result.set("When Alexander Graham Bell invented the telephone, "
                        + "he had three missed calls from Chuck Norris")
        );
        return result.get();
    }
}
