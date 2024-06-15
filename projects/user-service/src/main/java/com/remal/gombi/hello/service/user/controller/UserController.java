/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  February 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Spring REST endpoint.
 */
package com.remal.gombi.hello.service.user.controller;

import com.remal.gombi.hello.commons.model.User;
import com.remal.gombi.hello.service.user.micrometer.MicrometerBuilder;
import com.remal.gombi.hello.service.user.monitoring.LogExecutionTime;
import io.micrometer.core.instrument.Timer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.concurrent.TimeUnit;

@Slf4j
@RestController
@RequestMapping("/api/user")
public class UserController {

    private final MicrometerBuilder micrometerBuilder;

    public UserController(MicrometerBuilder micrometerBuilder) {
        this.micrometerBuilder = micrometerBuilder;
    }

    @GetMapping("/{id}")
    @LogExecutionTime
    public User getUser(@PathVariable("id") String id) {
        long start = System.nanoTime();
        String meterId = "get_user";
        Timer timer = micrometerBuilder.getTimer(meterId);

        try {
            User user = User.builder()
                    .username(id)
                    .email("arnold.somogyi@gmail.com")
                    .description("project owner")
                    .build();

            micrometerBuilder.getCounter(meterId, HttpStatus.OK.name()).increment();
            return user;
        } catch (RuntimeException e) {
            micrometerBuilder.getCounter(meterId, HttpStatus.INTERNAL_SERVER_ERROR.name()).increment();
            throw new RuntimeException(e);
        } finally {
            timer.record(System.nanoTime() - start, TimeUnit.NANOSECONDS);
        }
    }
}
