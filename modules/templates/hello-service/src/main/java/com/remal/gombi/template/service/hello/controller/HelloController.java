/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since: February 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Spring REST endpoint.
 */
package com.remal.gombi.template.service.hello.controller;

import com.remal.gombi.template.commons.model.User;
import com.remal.gombi.template.service.hello.monitoring.LogCall;
import com.remal.gombi.template.service.hello.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Slf4j
@RestController
@RequestMapping("/api/hello")
public class HelloController {

    private final UserService userService;

    /**
     * Constructor with object injections.
     *
     * @param userService object to be injected by spring
     */
    public HelloController(UserService userService) {
        this.userService = userService;
    }

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyy-MM-dd HH:mm:ss");

    @GetMapping("")
    @LogCall
    public String sayHello() {
        User user = userService.getUser("arnold");
        return String.format("Hello <b>%s</b>, the time is <b>%s</b>.",
                user.getUsername(),
                LocalDateTime.now().format(DATE_TIME_FORMATTER));
    }
}
