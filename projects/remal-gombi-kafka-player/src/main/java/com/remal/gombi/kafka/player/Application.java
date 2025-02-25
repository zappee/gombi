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
import picocli.CommandLine.Help;
import picocli.CommandLine.Help.Ansi;
import picocli.CommandLine.Help.Ansi.Text;
import picocli.CommandLine.Help.ColorScheme;
import picocli.CommandLine.INegatableOptionTransformer;
import picocli.CommandLine.Model.OptionSpec;

import java.util.ArrayList;
import java.util.List;

class Application {

    private static final Text EMPTY = Ansi.OFF.text("");

    /**
     * Application entry point.
     * <PRE>
     * By default, the following simple code can be used to start the picocli
     * command-line application:
     *
     * {@code
     *    public static void main(String... args) {
     *        int exitCode = new CommandLine(new PlayCommand()).execute(args);
     *        System.exit(exitCode);
     *    }
     * }
     *
     * But as we would like to hide the param labels we need to use this complex
     * code here.
     * </PRE>
     *
     * @param args command line parametersprovided by the user
     */
    public static void main(String... args) {
        CommandLine cmd = new CommandLine(new PlayCommand());
        cmd.setHelpFactory((commandSpec, colorScheme) -> new Help(commandSpec, colorScheme) {

            @Override
            public IOptionRenderer createDefaultOptionRenderer() {
                return (option, ignored, scheme) -> makeOptionList(option, scheme);
            }
        });
        cmd.usage(System.out);
    }

    /**
     * Shows usage help without param labels.
     * <a href="https://github.com/remkop/picocli/blob/main/picocli-examples/src/main/java/picocli/examples/customhelp/HideOptionParams.java">reference code</a>
     *
     * @param option the command model to create usage help for
     * @param scheme the color scheme to use
     * @return a new Help instance with the specified color scheme
     */
    private static Text[][] makeOptionList(OptionSpec option, ColorScheme scheme) {
        String shortOption = option.shortestName();
        String longOption = option.longestName();

        if (option.negatable()) {
            INegatableOptionTransformer transformer = option.command().negatableOptionTransformer();
            shortOption = transformer.makeSynopsis(shortOption, option.command());
            longOption = transformer.makeSynopsis(longOption, option.command());
        }

        String[] description = option.description();
        Text[] descriptionFirstLines = scheme.text(description[0]).splitLines();

        List<Text[]> result = new ArrayList<>();
        result.add(new Text[] {
                scheme.optionText(String.valueOf(option.command().usageMessage().requiredOptionMarker())),
                scheme.optionText(shortOption),
                scheme.text(","),
                scheme.optionText(longOption),
                descriptionFirstLines[0]
        });

        for (int i = 1; i < descriptionFirstLines.length; i++) {
            result.add(new Text[]{EMPTY, EMPTY, EMPTY, EMPTY, descriptionFirstLines[i]});
        }

        if (option.command().usageMessage().showDefaultValues()) {
            Text defaultValue = scheme.text("  Default: " + option.defaultValueString(true));
            result.add(new Text[]{EMPTY, EMPTY, EMPTY, EMPTY, defaultValue});
        }

        return result.toArray(new Text[result.size()][]);
    }
}
