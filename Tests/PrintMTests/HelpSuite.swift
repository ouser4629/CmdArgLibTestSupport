//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibTestSupport
import PrintMSource
import Testing

struct HelpSuite {

    // Note: this test assumes termimal width of 80
    @Test func helpTest1() {
        let input = """
            --help
            """
        let expected = """
            DESCRIPTION
              Print a phrase multiple times.

            USAGE
              test-print-m [-hlu] [--count <int>] <phrase>

            PARAMETERS
              -h/--help             Show help information.
              -l                    Lowercase the output.
              -u                    Uppercase the output.
              --count <int>         The number of times to print the phrase (default: 1).
              <phrase>              The phrase to print.

            NOTE
              The -l and -u flags shadow each other. The last one specified takes
              precedence.
            """
        let ok = testOutput(of: PrintMSource.run, with: input, expecting: expected)
        #expect(ok)
    }

    // This test fails
    @Test func helpTest2() {
        let input = """
            --help
            """
        let expected = """
            DESCRIPTION
              Print a phrase multiple times.

            USAGE
              test-print-m [-hlu] [--count <int>] <phrase>

            PARAMETERS
              -h/--help             Show help info.
              -l                    Lower the output.
              -u                    Uppercase the output.
              --count <int>         The number of times to print the phrase (default: 1).
              <phrase>              The phrase to print.

            NOTES
              The -l and -u flags shadow each other. The last one specified takes
              precedence.
            """
        let ok = testOutput(of: PrintMSource.run, with: input, expecting: expected)
        #expect(ok)
    }
}
