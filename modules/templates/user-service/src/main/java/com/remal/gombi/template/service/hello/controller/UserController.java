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
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/user")
public class UserController {

    @GetMapping("/{id}")
    @LogCall
    public User getUser(@PathVariable("id") String id) {
        return User.builder().username(id).build();
    }
}
