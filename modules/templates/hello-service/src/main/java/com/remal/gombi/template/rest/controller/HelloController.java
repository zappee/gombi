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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Slf4j
@RestController
@RequestMapping("/api/hello")
public class HelloController {

    @Value("${app.hello.name}")
    private String hello;

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyy-MM-dd HH:mm:ss");
    @GetMapping("")
    public String sayHello() {
        var response = String.format("Hello <b>%s</b>, the time is <b>%s</b>.",
                hello,
                LocalDateTime.now().format(DATE_TIME_FORMATTER));

        log.debug(String.format("calling sayHello(): {response: \"%s\"}", response));
        return response;
    }
}
