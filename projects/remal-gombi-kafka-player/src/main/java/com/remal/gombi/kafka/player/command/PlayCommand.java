/*
 *  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  February 2025
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Picocli command.
 */
package com.remal.gombi.kafka.player.command;

import org.springframework.stereotype.Component;
import picocli.CommandLine.Command;
import picocli.CommandLine.Option;

import java.util.concurrent.Callable;

@Component
@Command(name = "play", mixinStandardHelpOptions = true)
public class PlayCommand implements Callable<Integer> {

    @Option(
            names = {"-H", "--db-host"},
            description = "Hostname of the database server",
            required = true,
            defaultValue = "localhost")
    private String dbHost;

    @Option(
            names = {"-P", "--db-port"},
            description = "Number of the port where the database server listens for requests.",
            required = true,
            defaultValue = "5432")
    private int dbPort;

    @Override
    public Integer call() {
        System.out.printf("mycommand was called with -x=%s and positionals: %s%n", dbHost, dbPort);
        return 23;
    }

    /*@Component
    @Command(name = "sub", mixinStandardHelpOptions = true, subcommands = PlayCommand.SubSub.class,
            exitCodeOnExecutionException = 34)
    static class Sub implements Callable<Integer> {
        @Option(names = "-y", description = "optional option")
        private String y;

        @Parameters(description = "positional params")
        private List<String> positionals;

        @Override
        public Integer call() {
            System.out.printf("mycommand sub was called with -y=%s and positionals: %s%n", y, positionals);
            return 33;
        }
    }

    @Component
    @Command(name = "subsub", mixinStandardHelpOptions = true,
            exitCodeOnExecutionException = 44)
    static class SubSub implements Callable<Integer> {
        @Option(names = "-z", description = "optional option")
        private String z;

        //@Autowired
        //private SomeService service;

        @Override
        public Integer call() {
            System.out.printf("mycommand sub subsub was called with -z=%s. Service says: '%s'%n", z);
            return 43;
        }
    }*/
}
