/*
 *  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  February 2025
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Picocli command.
 */
package com.remal.gombi.kafka.player.picocli.command;

import picocli.CommandLine;

import java.util.concurrent.Callable;

@CommandLine.Command(
        name = "play", mixinStandardHelpOptions = true,
        usageHelpWidth = 100,
        header = {
                "@|bold,yellow ______ _______ _______ _______|@",
                "@|bold,yellow |_____/ |______ |  |  | |_____| ||@",
                "@|bold,yellow |    \\_ |______ |  |  | |     | |_____|@",
                "@|bold,yellow _______  _____  _______ _______ _  _  _ _______  ______ _______|@",
                "@|bold,yellow |______ |     | |______    |    |  |  | |_____| |_____/ |______|@",
                "@|bold,yellow ______| |_____| |          |    |__|__| |     | |    \\_ |______|@%n",
                "@|yellow :: remal-kafka-player :: 0.4.0 ::|@",
                "@|yellow Copyright (c) 2020-2025 REMAL SOFTWARE and Arnold Somogyi All rights reserved|@",
                "%n"},
        description = "Re-inject saved messages to a Kafka topic.%n")
public class PlayCommand implements  Callable<Integer> {

    @CommandLine.Option(
            names = {"-H", "--db-host"},
            description = "Hostname of the database server. Default: ${DEFAULT-VALUE}",
            required = true,
            defaultValue = "localhost")
    private String dbHost;

    @CommandLine.Option(
            names = {"-P", "--db-port"},
            description = "Number of the port where the database server listens for requests. Default: ${DEFAULT-VALUE}",
            required = true,
            defaultValue = "5432")
    private int dbPort;

    @Override
    public Integer call() throws Exception { // your business logic goes here...
        System.out.println("Connecting to " + dbHost + ":" + dbPort);
        return 0;
    }
}
