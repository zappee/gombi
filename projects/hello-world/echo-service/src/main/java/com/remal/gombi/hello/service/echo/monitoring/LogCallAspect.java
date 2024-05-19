/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  March 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Custom annotation to log the execution time of a method.
 */
package com.remal.gombi.hello.service.echo.monitoring;

import com.remal.gombi.hello.commons.spring.monitoring.MethodCallLogger;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Aspect
@Component
@Slf4j
public class LogCallAspect extends MethodCallLogger {

    @Autowired
    HttpServletRequest request;

    @Around("@annotation(com.remal.gombi.hello.service.echo.monitoring.LogCall)")
    public Object log(ProceedingJoinPoint joinPoint) throws Throwable {
        LogCall lc = ((MethodSignature) joinPoint.getSignature()).getMethod().getAnnotation(LogCall.class);
        return logMethodCall(joinPoint, lc.targets(), request);
    }
}
