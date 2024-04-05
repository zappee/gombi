/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  March 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Custom annotation to log the execution time of a method.
 */
package com.remal.gombi.template.service.hello.monitoring;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface LogCall {
    String[] targets() default {"log", "dashboard"};
}
