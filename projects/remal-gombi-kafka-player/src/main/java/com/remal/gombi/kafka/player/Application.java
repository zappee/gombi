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
import com.remal.gombi.kafka.player.picocli.renderer.CustomOptionRenderer;
import picocli.CommandLine;

class Application {

    /**
     * Application entry point.
     *
     * @param args command line parametersprovided by the user
     */
    public static void main(String... args) {
        CommandLine cmd = new CommandLine(new PlayCommand());
        cmd.setHelpFactory(new CustomOptionRenderer());
        int exitCode = cmd.execute(args);
        System.exit(exitCode);
    }
}
