/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since: March 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Custom annotation to log the execution time of a method.
 */
package com.remal.gombi.template.commons.spring.monitoring;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.util.StopWatch;

import java.util.Arrays;
import java.util.Objects;
import java.util.function.Predicate;

@Slf4j
public class MethodCallLogger {

    public Object logMethodCall(ProceedingJoinPoint joinPoint, String[] targets) throws Throwable {
        Predicate< String > targetLog = word -> word.equals("log");
        if (log.isDebugEnabled() && Arrays.stream(targets).anyMatch(targetLog)) {
            String methodName = joinPoint.getSignature().toShortString();
            log.debug("calling {} method...", methodName);

            StopWatch stopWatch = new StopWatch();
            stopWatch.start();

            Object object = joinPoint.proceed();

            stopWatch.stop();

            log.debug("method call details: {execution-time-in-ms: {}, method-name: {}, arguments: {}, return: {}}",
                    stopWatch.getTotalTimeMillis(),
                    methodName,
                    getArgumentsAsString(joinPoint),
                    getReturnValueAsString(object));
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
            sb.append(String.format("[arg-name: \"%s\", arg-value: \"%s\"]", argumentName, argumentValue.toString()));
            if (i < argumentNames.length-1) {
                sb.append(", ");
            }
        }
        return sb.toString().isBlank() ? "\"\"" : sb.toString();
    }

    private String getReturnValueAsString(Object object) {
        if (Objects.nonNull(object)) {
            /*return switch (object) {
                case String s -> String.format("\"%s\"", object);
                default -> object.toString();
            };*/
            if (object instanceof String) {
                return String.format("\"%s\"", object);
            } else {
                return object.toString();
            }
        }
        return "<null>";
    }
}
