/*
 *  Copyright (c) 2020-2024 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since: February 2024
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Custom exception class.
 */
package com.remal.gombi.template.rest.exception;

public class InitializationException extends RuntimeException {

    public InitializationException(String message, Exception e) {
        super(message, e);
    }
}
