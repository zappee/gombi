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
import io.micrometer.core.instrument.Timer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.concurrent.atomic.AtomicReference;

@Slf4j
@RestController
@RequestMapping("/api/user")
public class UserController {

    private final Timer getUserTimer;

    public UserController(MicrometerBuilder micrometer) {
        getUserTimer = micrometer.getMeasureExecutionTimeMeter("get_user");
    }

    @GetMapping("/{id}")
    @LogCall
    public User getUser(@PathVariable("id") String id) {
        AtomicReference<User> user = new AtomicReference<>();
        getUserTimer.record(() -> user.set(User.builder().username(id).build()));
        return user.get();
    }
}
