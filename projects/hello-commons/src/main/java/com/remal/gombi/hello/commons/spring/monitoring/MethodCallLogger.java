/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  March 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Custom annotation to log the execution time of a method.
 */
package com.remal.gombi.hello.commons.spring.monitoring;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.util.StopWatch;

import java.util.Arrays;
import java.util.Objects;
import java.util.function.Predicate;

@Slf4j
public class MethodCallLogger {

    public Object logMethodCall(ProceedingJoinPoint joinPoint,
                                String[] targets,
                                HttpServletRequest request) throws Throwable {
        Predicate< String > targetLog = word -> word.equals("slf4j");
        if (log.isDebugEnabled() && Arrays.stream(targets).anyMatch(targetLog)) {
            String methodName = joinPoint.getSignature().toShortString();
            log.debug("calling {} method...", methodName);

            StopWatch stopWatch = new StopWatch();
            stopWatch.start();

            Object object = joinPoint.proceed();

            stopWatch.stop();

            if (Objects.isNull(request)) {
                log.debug("method call ended: {method-name: {}, arguments: {}, return: {}, execution-time-in-ms: {}}",
                        methodName,
                        getArgumentsAsString(joinPoint),
                        getReturnValueAsString(object),
                        stopWatch.getTotalTimeMillis());
            } else {
                String remoteHost = Objects.nonNull(request.getHeader("X-FORWARDED-FOR"))
                        ? request.getHeader("X-FORWARDED-FOR")
                        : request.getRemoteHost();
                log.debug("method call ended: {method-name: {}, arguments: {}, return: {}, execution-time-in-ms: {}, remote-host: {}}",
                        methodName,
                        getArgumentsAsString(joinPoint),
                        getReturnValueAsString(object),
                        stopWatch.getTotalTimeMillis(),
                        remoteHost);
            }
            return object;
        } else {
            return joinPoint.proceed();
        }
    }

    private String getArgumentsAsString(ProceedingJoinPoint joinPoint) {
        StringBuilder sb = new StringBuilder();
        String[] argumentNames = ((MethodSignature) joinPoint.getSignature()).getParameterNames();
        Object[] argumentValues = joinPoint.getArgs();

        for (int i = 0; i < argumentNames.length; i++) {
            String argumentName = argumentNames[i];
            Object argumentValue = argumentValues[i];
            sb.append(String.format("[name: \"%s\", value: \"%s\"]", argumentName, argumentValue.toString()));
            if (i < argumentNames.length-1) {
                sb.append(", ");
            }
        }
        return sb.toString().isBlank() ? "\"\"" : sb.toString();
    }

    private String getReturnValueAsString(Object object) {
        if (Objects.nonNull(object)) {
            return switch (object) {
                case String value -> "\"" + value + "\"";
                case Integer value -> value.toString();
                default -> object.toString();
            };
        }
        return "<null>";
    }
}
