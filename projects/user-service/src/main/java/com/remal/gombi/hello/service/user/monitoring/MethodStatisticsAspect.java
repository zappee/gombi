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

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.Timer;
import io.micrometer.core.instrument.composite.CompositeMeterRegistry;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;

import java.util.Objects;
import java.util.concurrent.TimeUnit;

@Component
@Aspect
@Slf4j
public class MethodStatisticsAspect {

    enum ProceedStatus {
        ok, error
    }

    private static final String TEMPLATE_WITH_RETURN = "method call ended: {name: {}, arguments: {}, return: {}, execution-in-ms: {}}";
    private static final String TEMPLATE_NO_RETURN = "method call ended: {name: {}, arguments: {}, return: <null>, execution-in-ms: {}}";

    private final CompositeMeterRegistry meterRegistry;

    /**
     * Constructor.
     *
     * @param meterRegistry micrometer's meters registry
     */
    public MethodStatisticsAspect(CompositeMeterRegistry meterRegistry) {
        this.meterRegistry = meterRegistry;
    }

    @Around("@annotation(com.remal.gombi.hello.service.user.monitoring.MethodStatistics)")
    public Object aroundAdvice(ProceedingJoinPoint joinPoint) throws Throwable {
        long startInNano = System.nanoTime();
        String className = joinPoint.getTarget().getClass().getSimpleName();
        String methodName = joinPoint.getSignature().getName();
        String fullQualifiedMethodName = className + "." + methodName;

        try {
            // log arguments before the call
            String arguments = getArgumentsAsString(joinPoint);
            if (arguments.isEmpty()) {
                log.debug("calling the {}() method...", fullQualifiedMethodName);
            } else {
                log.debug("calling the {}() method with parameters: {}...", fullQualifiedMethodName, arguments);
            }

            // call the method
            Object o = joinPoint.proceed();

            // log the result of the call
            getCounter(fullQualifiedMethodName, ProceedStatus.ok).increment();
            String returnValue = getReturnValueAsString(o);
            long endInMilli = (System.nanoTime() - startInNano) / 1000000;
            if (Objects.nonNull(o)) {
                log.debug(TEMPLATE_WITH_RETURN, fullQualifiedMethodName, arguments, returnValue, endInMilli);
            } else {
                log.debug(TEMPLATE_NO_RETURN, fullQualifiedMethodName, arguments, endInMilli);
            }
            return o;

        } catch(Throwable t) {
            getCounter(fullQualifiedMethodName, ProceedStatus.error).increment();
            throw new Throwable(t);
        } finally {
            getTimer(fullQualifiedMethodName).record(System.nanoTime() - startInNano, TimeUnit.NANOSECONDS);
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
        return sb.toString();
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

    private Timer getTimer(String id) {
        return Timer
                .builder("java_method_execution_time")
                .tag("id", id)
                .description("execution time of a Java method")
                .register(meterRegistry);
    }

    private Counter getCounter(String id, ProceedStatus status) {
        return Counter
                .builder("java_method_call_result")
                .tags("id", id, "status", status.name())
                .description("total number of the method calls")
                .register(meterRegistry);
    }
}
