/*
 *  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  February 2025
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Application entry point.
 */
package com.remal.gombi.kafka.player;

import com.remal.gombi.kafka.player.picocli.command.PlayCommand;
import picocli.CommandLine;

class Application {

    public static void main(String... args) {
        int exitCode = new CommandLine(new PlayCommand()).execute(args);
        System.exit(exitCode);
    }
}
