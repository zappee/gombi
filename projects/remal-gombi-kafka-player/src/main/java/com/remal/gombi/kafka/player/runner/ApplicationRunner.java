/*
 *  Copyright (c) 2020-2025 Remal Software and Arnold Somogyi All rights reserved
 *
 *  Since:  February 2025
 *  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
 *
 *  Description:
 *     Picocli command runner.
 */
package com.remal.gombi.kafka.player.runner;

import com.remal.gombi.kafka.player.command.PlayCommand;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.ExitCodeGenerator;
import org.springframework.stereotype.Component;
import picocli.CommandLine;

@Component
@RequiredArgsConstructor
public class ApplicationRunner implements CommandLineRunner, ExitCodeGenerator {

    private final PlayCommand playCommand;
    private final CommandLine.IFactory factory;

    private int exitCode;

    @Override
    public void run(String... args) throws Exception {
        exitCode = new CommandLine(playCommand, factory).execute(args);
    }

    @Override
    public int getExitCode() {
        return exitCode;
    }
}
