/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  March 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Custom annotation to log the execution time of a method.
 */
package com.remal.gombi.hello.service.user.monitoring;

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
public class ExecutionTimeAspect extends MethodCallLogger {

    @Autowired
    HttpServletRequest request;

    @Around("@annotation(com.remal.gombi.hello.service.user.monitoring.LogExecutionTime)")
    public Object logExecutionTime(ProceedingJoinPoint joinPoint) throws Throwable {
        LogExecutionTime annotation = ((MethodSignature) joinPoint.getSignature()).getMethod().getAnnotation(LogExecutionTime.class);
        return logMethodCall(joinPoint, annotation.targets(), request);
    }
}
