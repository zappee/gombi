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
import com.remal.gombi.hello.service.echo.service.ConfigurationService;
import com.remal.gombi.hello.service.echo.service.UserService;
import io.micrometer.core.instrument.Timer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Objects;
import java.util.concurrent.TimeUnit;

@Slf4j
@RestController
@RequestMapping("/api")
public class EchoController {

    private final ConfigurationService configuration;
    private final UserService userService;
  //  private final MicrometerBuilder micrometerBuilder;

    /**
     * Constructor with object injections.
     *
     * @param userService object to be injected by spring
     */
    public EchoController(UserService userService,
                          ConfigurationService configuration/*,
                          MicrometerBuilder micrometerBuilder*/) {
        this.userService = userService;
        this.configuration = configuration;
        //this.micrometerBuilder = micrometerBuilder;
    }

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyy-MM-dd HH:mm:ss");

    @GetMapping("echo")
  //  @LogExecutionTime
    public String echo() {
        long start = System.nanoTime();
//        String meterId = "echo";
        //Timer timer = micrometerBuilder.getTimer(meterId);

        try {
            String description = (Math.random() < 0.5) ? configuration.getOptionA() : configuration.getOptionB();
            User user = userService.getUser("1");
            user.setDescription(description);

            String now = LocalDateTime.now().format(DATE_TIME_FORMATTER);
            String message = String.format("Hello %s, the time is %s.", user.getEmail(), now);
            message += Objects.nonNull((user.getDescription())) ? "<br>" + user.getDescription() : "";

         //   micrometerBuilder.getCounter(meterId, HttpStatus.OK.name()).increment();
            return message;
        } catch (RuntimeException e) {
          //  micrometerBuilder.getCounter(meterId, HttpStatus.INTERNAL_SERVER_ERROR.name()).increment();
            throw new RuntimeException(e);
        } finally {
           // timer.record(System.nanoTime() - start, TimeUnit.NANOSECONDS);
        }
    }

    @GetMapping("joke")
  //  @LogExecutionTime
    public String joke() {
        long start = System.nanoTime();
        String meterId = "joke";
      //  Timer timer = micrometerBuilder.getTimer(meterId);

        try {
            String response = "When Alexander Graham Bell invented the telephone, he had three missed calls from Chuck Norris";

        //    micrometerBuilder.getCounter(meterId, HttpStatus.OK.name()).increment();
            return response;
        } catch (RuntimeException e) {
        //    micrometerBuilder.getCounter(meterId, HttpStatus.INTERNAL_SERVER_ERROR.name()).increment();
            throw new RuntimeException(e);
        } finally {
       //     timer.record(System.nanoTime() - start, TimeUnit.NANOSECONDS);
        }
    }
}
