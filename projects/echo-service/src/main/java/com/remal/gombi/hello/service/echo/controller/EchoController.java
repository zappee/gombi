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

import com.remal.gombi.hello.commons.model.User;
import com.remal.gombi.hello.commons.monitoring.MethodStatistics;
import com.remal.gombi.hello.service.echo.service.ConfigurationService;
import com.remal.gombi.hello.service.echo.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Objects;

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
    @MethodStatistics
    public String echo() {
        String description = (Math.random() < 0.5) ? configuration.getOptionA() : configuration.getOptionB();
        User user = userService.getUser("1");
        user.setDescription(description);

        String now = LocalDateTime.now().format(DATE_TIME_FORMATTER);
        String message = String.format("Hello %s, the time is %s.", user.getEmail(), now);
        message += Objects.nonNull((user.getDescription())) ? "<br>" + user.getDescription() : "";

        return message;
    }

    @GetMapping("joke")
    @MethodStatistics
    public String joke() {
            return "When Alexander Graham Bell invented the telephone, he had three missed calls from Chuck Norris";
    }
}
