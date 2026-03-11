/*
 *  Copyright (c) 2020-2026 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  February 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Spring application entry point.
 */
package com.remal.gombi.service.user;

import org.springframework.boot.WebApplicationType;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan({"com.remal.gombi.service.user", "com.remal.gombi.commons.spring"})
public class Application {

    public static void main(String[] args) {
        new SpringApplicationBuilder(Application.class).web(WebApplicationType.SERVLET).run(args);
    }
}
