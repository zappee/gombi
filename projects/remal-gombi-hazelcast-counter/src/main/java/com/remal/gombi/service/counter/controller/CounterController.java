/*
 *  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  February 2025
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Spring REST endpoint.
 */
package com.remal.gombi.service.counter.controller;

import com.remal.gombi.commons.monitoring.MethodStatistics;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Slf4j
@RestController
@RequestMapping("/api/counter")
public class CounterController {

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyy-MM-dd HH:mm:ss");

    @GetMapping("show")
    @MethodStatistics
    public String showCurrentState() {
        var now = LocalDateTime.now().format(DATE_TIME_FORMATTER);
        var response = "xxxxx";
        return now + "<br>" + response;
    }

    @GetMapping("update")
    @MethodStatistics
    public String updateCurrentState() {
        var now = LocalDateTime.now().format(DATE_TIME_FORMATTER);
        var response = "yyyy";
        return now + "<br>" + response;
    }
}
