/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  February 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Spring REST endpoint.
 */
package com.remal.gombi.hello.service.welcome.controller;

import com.remal.gombi.hello.commons.monitoring.MethodStatistics;
import com.remal.gombi.hello.service.welcome.service.TemplateService;
import com.remal.gombi.hello.service.welcome.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Objects;

@Slf4j
@RestController
@RequestMapping("/api")
public class WelcomeController {

    private final TemplateService templateService;
    private final UserService userService;

    /**
     * Constructor with object injections.
     *
     * @param userService object to be injected by spring
     */
    public WelcomeController(UserService userService,
                             TemplateService templateService) {
        this.userService = userService;
        this.templateService = templateService;
    }

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyy-MM-dd HH:mm:ss");

    @GetMapping("welcome/{username}")
    @MethodStatistics
    public String welcome(@PathVariable String username) {
        var template = templateService.getWelcomeTemplate();
        return generateWelcomeMessage(username, template);
    }

    @GetMapping("welcome-back/{username}")
    @MethodStatistics
    public String welcomeBack(@PathVariable String username) {
        var template = templateService.getWelcomeBackTemplate();
        return generateWelcomeMessage(username, template);
    }

    private String generateWelcomeMessage(String username, String template) {
        var user = userService.getUser(username);
        var message = Objects.isNull(user) ? "Unknown user." : String.format(template, user.getFirstName());
        var now = LocalDateTime.now().format(DATE_TIME_FORMATTER);
        return now + "<br>" + message;
    }

    @GetMapping("joke")
    @MethodStatistics
    public String joke() {
            return "When Alexander Graham Bell invented the telephone, he had three missed calls from Chuck Norris";
    }
}
