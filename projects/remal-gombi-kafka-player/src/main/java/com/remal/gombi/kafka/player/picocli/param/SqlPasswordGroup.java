/*
 *  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  February 2025
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Picocli command group.
 */
package com.remal.gombi.kafka.player.picocli.param;


import lombok.Getter;
import picocli.CommandLine;

/**
 * SQL password argument group.
 */
@Getter
public class SqlPasswordGroup {
    @CommandLine.Option(
            names = {"-S", "--sql-password"},
            required = true,
            description = "Password for the connecting user.")
    private String password;

    @CommandLine.Option(
            names = {"-I", "--sql-iPassword"},
            required = true,
            interactive = true,
            description = "Interactive way to get the password for the connecting user.")
    private String interactivePassword;
}
